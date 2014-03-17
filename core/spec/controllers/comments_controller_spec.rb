require 'spec_helper'

describe CommentsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :index do
    it "should render json successful" do
      FactoryGirl.reload

      other_user = create(:user)

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     site_title: 'title')
      end
      as(other_user) do |pavlov|
        pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, content: 'a comment')
      end

      as(user) do |pavlov|
        comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, content: 'a comment')
        pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'disbelieves')
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)

      get :index, id: fact.id, format: :json

      verify { response.body }
    end
  end

  describe :create do
    it "should return the correct json" do
      FactoryGirl.reload

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     site_title: 'title')
      end

      post :create, id: fact.id, content: 'Gerard is een gekke meneer', format: :json

      verify { response.body }
    end
  end
end
