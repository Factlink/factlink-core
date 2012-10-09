require 'integration_helper'

describe "Compare screens", type: :request do
  
  it "should render the frontpage as expected" do
    visit "/?show_sign_in=true"
    assume_unchanged_screenshot "homepage"
  end

  [0,1,2,3,5,6].each do |i|
    it "should render the fake factpage with cid #{i} as expected" do
      visit "/x/3?cid=#{i}"
      assume_unchanged_screenshot "fake_fact_#{i}"
    end
  end

end