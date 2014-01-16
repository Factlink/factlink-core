require 'screenshot_helper'

describe "Non signed in pages:", type: :feature, driver: :poltergeist_slow do
  include Acceptance::FactHelper

  describe "Profile page page" do
    it "renders correctly" do
      @user = sign_in_user create :full_user

      factlink = backend_create_fact

      sign_out_user
      visit user_path(@user)

      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
