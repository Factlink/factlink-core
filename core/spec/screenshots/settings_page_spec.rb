require 'acceptance_helper'

describe "factlink", type: :feature do
  include ScreenshotTest

  before :each do
    @user = sign_in_user create :user
  end

  it "the layout of the settings page is correct" do
    visit edit_user_path(@user)

    expect(page).to have_field('Full name', with: @user.full_name)

    assume_unchanged_screenshot "settings_page"
  end
end
