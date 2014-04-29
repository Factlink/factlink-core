require 'acceptance_helper'

describe "factlink", type: :feature do
  include ScreenshotTest

  before :each do
    @user = sign_in_user create :user
  end

  it "the layout of the search page is correct" do
    visit "/search?s=oil"

    page.should have_content "Sorry, your search didn't return any results"

    assume_unchanged_screenshot "search"
  end
end
