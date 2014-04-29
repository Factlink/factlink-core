require 'spec_helper'

describe SitesController do
  include PavlovSupport

  let(:user) { create(:user) }

  describe :facts_for_url do
    describe "authorized" do
      it "should work with an non-existing site" do
        get :facts_for_url, url: "http://www.thebaronisinthebuilding.com/"
        response.body.should eq("[]")
      end

      it "should render json successful" do
        url = 'http://bla.com/foo'

        as(user) do |pavlov|
          pavlov.interactor(:'facts/create',
                           displaystring: 'displaystring',
                           site_url: url,
                           site_title: 'title')
        end

        get :facts_for_url, url: url, format: :json
        response.should be_success

        verify { response.body }
      end
    end
  end
end
