require 'spec_helper'

describe SitesController do
  include PavlovSupport

  let(:user) { create(:full_user) }

  describe :facts_for_url do
    describe "authorized" do
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

        verify { response.body }
      end
    end
  end
end
