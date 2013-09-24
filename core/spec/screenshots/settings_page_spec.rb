require 'screenshot_helper'

describe "factlink", type: :feature do
  before :each do
    @user = sign_in_user create :full_user, features: [:delete_account]
  end

  it "the layout of the settings page is correct" do
    visit edit_user_path(@user)
    assume_unchanged_screenshot "settings_page"
  end
end
