require 'spec_helper'

describe CommentsController do
  include PavlovSupport

  render_views

  let(:user) { create(:full_user) }

  describe :index do
    it "should render json successful" do
      FactoryGirl.reload

      other_user = create(:full_user)

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title')
      end
      as(other_user) do |pavlov|
        pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'doubts', content: 'a comment')
      end

      as(user) do |pavlov|
        pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'doubts', content: 'a comment')
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :show, fact

      get :index, id: fact.id, format: :json

      verify(format: :json) { response.body }
    end
  end
end
