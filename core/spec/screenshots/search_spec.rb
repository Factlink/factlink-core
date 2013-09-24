require 'screenshot_helper'

describe "factlink", type: :feature do
  before :each do
    @user = sign_in_user create :full_user
  end

  it "the layout of the search page is correct" do

    visit "/search?s=oil"

    assume_unchanged_screenshot "search"
  end
end
