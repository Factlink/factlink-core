require 'spec_helper'

describe SitesController do

  describe "gets count for page" do
    
    it "should return 0 for site with no facts" do
      get "facts_count_for_url", { :url => "http://baronie.nl" }
      parsed_content = JSON.parse(response.body)
      parsed_content.should have_key("count")
      parsed_content['count'].should == 0
    end
    
  end

  describe :factlinks_for_url do
    it "should work with an existing site" do
      @site = FactoryGirl.create(:site, :url => "http://batman.org")
      get :facts_for_url, :url => @site.url
      response.body.should eq("[]")
    end

    # Facts don't get set properly?
    it "should return results for an existing site with facts" do

      pending

      @site = FactoryGirl.create(:site, :url => "http://batman.org")
      
      @site.facts << FactoryGirl.create(:fact, :displaystring => "This is Fact one")
      @site.facts << FactoryGirl.create(:fact, :displaystring => "This is Fact two")
      
      get :facts_for_url, :url => @site.url
      response.body.should eq("[...the facts as json...]")
    end
    
    it "should work with an non-existing site" do

      get :facts_for_url, :url => "http://www.thebaronisinthebuilding.com/"
      response.body.should eq("[]")
    end
  end 
end