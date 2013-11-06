require 'screenshot_helper'

describe "Static pages:", type: :feature do
  describe "Homepage" do
    it "with sign-in open as expected" do
      visit "/?show_sign_in=true"
      assume_unchanged_screenshot "static_homepage"
    end

    it "with open feedback as expected" do
      visit "/"

      find('a', text: 'Feedback').click
      within_frame 0 do
        # wait for frame to load:
        find(:button, 'Send feedback')
      end
      assume_unchanged_screenshot "static_homepage_with_feedback"
    end
  end

  describe "About page" do
    it "it renders correctly" do
      visit "/p/about"
      assume_unchanged_screenshot "static_about"
    end
  end

  describe "Team page" do
    it "it renders correctly" do
      visit "/p/team"
      assume_unchanged_screenshot "static_team"
    end
  end

  describe "Jobs page" do
    it "it renders correctly" do
      visit "/p/jobs"
      assume_unchanged_screenshot "static_jobs"
    end
  end

  describe "Contact page" do
    it "it renders correctly" do
      visit "/p/contact"
      assume_unchanged_screenshot "static_contact"
    end
  end

  describe "Privacy page" do
    it "it renders correctly" do
      visit "/p/privacy"
      assume_unchanged_screenshot "static_privacy"
    end
  end

  describe "TOS page" do
    it "it renders correctly" do
      visit "/p/terms-of-service"
      assume_unchanged_screenshot "static_tos"
    end
  end
end
