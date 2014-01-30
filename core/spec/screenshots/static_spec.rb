require 'acceptance_helper'

describe "Static pages:", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest

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
end
