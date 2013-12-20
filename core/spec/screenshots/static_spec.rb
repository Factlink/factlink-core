require 'screenshot_helper'

describe "Static pages:", type: :feature, driver: :poltergeist_slow do
  describe "Homepage" do
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
    it "renders correctly" do
      visit "/p/about"
      assume_unchanged_screenshot "static_about"
    end
  end

  describe "Team page" do
    it "renders correctly" do
      visit "/p/team"
      assume_unchanged_screenshot "static_team"
    end
  end

  describe "Jobs page" do
    it "renders correctly" do
      visit "/p/jobs"
      assume_unchanged_screenshot "static_jobs"
    end
  end

  describe "Contact page" do
    it "renders correctly" do
      visit "/p/contact"
      assume_unchanged_screenshot "static_contact"
    end
  end

  describe "Privacy page" do
    it "renders correctly" do
      visit "/p/privacy"
      assume_unchanged_screenshot "static_privacy"
    end
  end

  describe "On your site page" do
    it "renders correctly" do
      visit "/p/on-your-site"
      assume_unchanged_screenshot "static_on_your_site"
    end
  end

  describe "Login and sign in screen" do
    it  "renders correctly" do
      visit "/users/sign_in_or_up"
      assume_unchanged_screenshot "static_sign_in_or_up"
    end
  end
end
