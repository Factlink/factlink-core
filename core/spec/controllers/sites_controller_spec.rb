require 'spec_helper'

describe SitesController do
  include PavlovSupport

  let(:user) { create(:full_user) }

  describe :facts_count_for_url do
    it "should return 0 for site with no facts" do
      should_check_can :get_fact_count, Site
      get "facts_count_for_url", { url: "http://baronie.nl" }
      parsed_content = JSON.parse(response.body)
      parsed_content.should have_key("count")
      parsed_content['count'].should == 0
    end
  end

  describe :facts_for_url do
    describe "unauthorized" do
      before do
        ability.should_receive(:can?).with(:index, Fact).and_return(false)
      end

      it "should work with an existing site" do
        @site = create(:site, url: "http://batman.org")
        get :facts_for_url, url: @site.url
        response.body.should eq("{\"error\":\"Unauthorized\"}")
      end

      it "should work with an non-existing site" do
        get :facts_for_url, url: "http://www.thebaronisinthebuilding.com/"
        response.body.should eq("{\"error\":\"Unauthorized\"}")
      end
    end

    describe "authorized" do
      before do
        ability.should_receive(:can?).with(:index, Fact).and_return(true)
      end

      it "should work with an existing site" do
        @site = create(:site, url: "http://batman.org")
        get :facts_for_url, url: @site.url
        response.body.should eq("[]")
      end

      it "should work with an non-existing site" do
        get :facts_for_url, url: "http://www.thebaronisinthebuilding.com/"
        response.body.should eq("[]")
      end

      it "should render json successful" do
        url = 'http://bla.com/foo'
        fact = nil

        as(user) do |pavlov|
          fact = pavlov.interactor(:'facts/create',
                                       displaystring: 'displaystring', url: url,
                                       title: 'title')
        end

        get :facts_for_url, url: url, format: :json
        response.should be_success

        Approvals.verify(response.body.to_s, format: :json, name: 'sites#facts_for_url_should_keep_the_same_content')
      end
    end
  end

  describe :blacklisted do
    it "should work with a non-blocked site" do
      get :blacklisted, url: 'http://batman.org/'
      response.body.should eq("{}")
    end
    it "should work with a blocked site" do
      get :blacklisted, url: 'http://factlink.com/'
      response.body.should eq("{\"blacklisted\":\"This site is not supported\"}")
    end
  end
end
