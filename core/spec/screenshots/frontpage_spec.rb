require 'screenshot_helper'

describe "Homepage rendering", type: :feature do
  it "with sign-in open as expected" do
    visit "/?show_sign_in=true"
    assume_unchanged_screenshot "homepage"
  end
  it "with empty submit and open feedback as expected" do
    visit "/"
    first('input[value="Reserve my username"]').click
    find('a', text: 'Feedback').click
    assume_unchanged_screenshot "homepage_with_feedback"
  end
end
