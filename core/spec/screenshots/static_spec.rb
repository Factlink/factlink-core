require 'acceptance_helper'

describe "Static pages:", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest

  describe "Homepage" do
    it do
      visit "/"
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
end
