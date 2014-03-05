require 'acceptance_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest

  before :each do
    @user = sign_in_user create :user
  end

  it "the layout of the search page is correct" do

    visit "/search?s=oil"

    assume_unchanged_screenshot "search"
  end
end
