require 'spec_helper'

describe ClientController do
  include PavlovSupport

  render_views

  let(:user) { create(:full_user) }

  describe :blank do
    it 'should render' do
      get :blank
      expect(response).to be_success
    end
  end

  describe :intermediate do
    it 'should render' do
      get :intermediate
      expect(response).to be_success
    end
  end

  describe :facts_new do
    it 'should render' do
      authenticate_user!(user)
      get :facts_new
      expect(response).to be_success
    end
  end

  describe :fact_show do
    it "should render successful" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      ability.stub(:can?).with(:show, Fact).and_return(true)
      ability.stub(:can?).with(:share_to, :twitter).and_return(false)
      ability.stub(:can?).with(:share_to, :facebook).and_return(false)
      should_check_can :show, fact

      get :fact_show, id: fact.id
      response.should be_success
    end
  end
end
