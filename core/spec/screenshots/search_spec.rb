require 'screenshot_helper'

describe "factlink", type: :request do
  before :each do
    @user = sign_in_user create :active_user
  end

  it "the layout of the search page is correct" do

    visit search_path("oil")

    assume_unchanged_screenshot "search"
  end
end
