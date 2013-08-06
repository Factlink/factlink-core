require 'screenshot_helper'

describe "Static pages:", type: :request do
  describe "Homepage rendering" do
    it "with sign-in open as expected" do
      visit "/?show_sign_in=true"
      assume_unchanged_screenshot "static_homepage"
    end
    it "with empty submit and open feedback as expected" do
      visit "/"
      find('input[value="Reserve my username"]').click
      find('a', text: 'Feedback').click
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
end
