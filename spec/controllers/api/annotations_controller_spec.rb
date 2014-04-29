require 'spec_helper'

describe Api::AnnotationsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :show do
    it "should render json successful" do
      FactoryGirl.reload

      authenticate_user!(user)
      dead_fact = nil

      as(user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')

        pavlov.interactor(:'facts/set_interesting', fact_id: dead_fact.id)
      end

      get :show, id: dead_fact.id, format: :json

      verify { response.body }
    end

    it "should render json successful for non-logged in users" do
      FactoryGirl.reload

      dead_fact = nil

      as(user) do |pavlov|
        dead_fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')

        pavlov.interactor(:'facts/set_interesting', fact_id: dead_fact.id)
      end

      get :show, id: dead_fact.id, format: :json

      verify { response.body }
    end
  end

  describe :create do
    it "should work with json" do
      authenticate_user!(user)
      post 'create', format: :json, site_url: "http://example.org/", displaystring: "Facity Fact", site_title: "Title"
      response.code.should eq("200")
    end
  end

  describe :search do
    it "should work" do
      authenticate_user!(user)

      as(user) do |pavlov|
        pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     site_url: 'url',
                                     site_title: 'title')

        pavlov.interactor(:'facts/create',
                              displaystring: 'oil dobedoo',
                              site_url: 'url',
                              site_title: 'title')
        pavlov.interactor(:'facts/create',
                              displaystring: 'you got oil mister?',
                              site_url: 'url',
                              site_title: 'title')

      end

      get :search, keywords: "oil"
      response.should be_success

      verify { response.body }
    end
  end
end
