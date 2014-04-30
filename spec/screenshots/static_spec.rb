require 'acceptance_helper'

describe "Static pages:", type: :feature do
  include ScreenshotTest
  include FeedHelper

  describe "Homepage" do
    it do
      create_default_activities_for create(:user)

      visit "/"
      find('.spec-feed-activity:first-child')

      assume_unchanged_screenshot "static_homepage"
    end
  end

  describe "Publisher landing page" do
    next if FactlinkUI.Kennisland?

    it "renders correct" do
      visit "/"

      first('a', text: 'On your site').click
      find('a', text: 'Other platforms').click

      assume_unchanged_screenshot "static_on_your_site"
    end
  end

  describe "Customer landing page" do
    it do
      visit "/in-your-browser"
      assume_unchanged_screenshot "static_in_your_browser"
    end
  end

  describe "Blog page" do
    it do
      visit '/blog/discussion-of-the-week-10'
      assume_unchanged_screenshot "static_blogpost"
    end
  end
end
