require 'acceptance_helper'

describe "Non signed in pages:", type: :feature do
  include ScreenshotTest
  include Acceptance::FactHelper

  describe "Profile page page" do
    it "renders correctly" do
      @user = sign_in_user create :user

      create :fact_data

      sign_out_user
      visit user_profile_path(@user)
      sleep 5
      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
