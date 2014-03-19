require 'spec_helper'

describe Api::AnnotationsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :show do
    it "should render json successful" do
      FactoryGirl.reload

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     site_title: 'title')
        Fact[fact.id].add_opinion :believes, user.graph_user
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)

      get :show, id: fact.id, format: :json

      verify { response.body }
    end

    it "should render json successful for non-logged in users" do
      FactoryGirl.reload

      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     site_title: 'title')
        Fact[fact.id].add_opinion :believes, user.graph_user
      end

      ability.should_receive(:can?).with(:show, Fact).and_return(true)

      get :show, id: fact.id, format: :json

      verify { response.body }
    end
  end

  describe :create do
    it "should work with json" do
      authenticate_user!(user)
      post 'create', format: :json, url: "http://example.org/", displaystring: "Facity Fact", site_title: "Title"
      response.code.should eq("200")
    end
  end

  describe :search do
    before do
      ElasticSearch.stub synchronous: true
    end
    it "should work" do
      authenticate_user!(user)

      as(user) do |pavlov|
        pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     site_title: 'title')

        pavlov.interactor(:'facts/create',
                              displaystring: 'oil dobedoo',
                              url: 'url',
                              site_title: 'title')
        pavlov.interactor(:'facts/create',
                              displaystring: 'you got oil mister?',
                              url: 'url',
                              site_title: 'title')

      end

      get :search, keywords: "oil"
      response.should be_success

      verify { response.body }
    end
  end
end
