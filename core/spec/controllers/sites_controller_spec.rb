require 'spec_helper'

describe SitesController do

  describe "gets count for page" do
    
    it "should return 0 for site with no facts" do
      get "count_for_site", { :url => "http://baronie.nl" }
      parsed_content = JSON.parse(response.body)
      parsed_content.should have_key("count")
      parsed_content['count'].should == 0
    end
    
  end
    
end