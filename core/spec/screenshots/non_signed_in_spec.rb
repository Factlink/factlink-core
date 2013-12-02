require 'screenshot_helper'

describe "Non signed in pages:", type: :feature do
  describe "Profile page page" do
    it "it renders correctly" do
      @user = sign_in_user create :full_user
      sign_out_user
      visit user_path(@user)

      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
