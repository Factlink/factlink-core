require 'acceptance_helper'

describe "Static pages:", type: :feature do
  include ScreenshotTest
  include FeedHelper

  describe "Homepage" do
    it do
      create_default_activities_for create(:user)

      visit "/"
      find('.spec-feed-activities-fixed .spec-feed-activity:first-child')

      assume_unchanged_screenshot "static_homepage"
    end
  end

  describe "Publisher landing page" do
    it "renders correct with feedback opened" do
      visit "/"

      first('a', text: 'On your site').click
      find('a', text: 'Other platforms').click

      find('a', text: 'Feedback').click
      within_frame 0 do
        # wait for frame to load:
        find(:button, 'Send feedback')
      end

      assume_unchanged_screenshot "static_on_your_site_with_feedback"
    end
  end

  describe "Customer landing page" do
    it do
      visit "/in-your-browser"
      assume_unchanged_screenshot "static_blogpost2"
    end
  end

  describe "Blog page" do
    it do
      visit blog_stubbing_the_object_under_test_and_getting_away_without_it_path
      assume_unchanged_screenshot "static_blogpost"
    end
  end
end
