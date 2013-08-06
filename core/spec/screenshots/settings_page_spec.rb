require 'screenshot_helper'

describe "factlink", type: :request do
  before :each do
    @user = sign_in_user create :active_user
  end

  it "the layout of the settings page is correct" do
    find('a.dropdown-toggle').click
    wait_for_ajax
    find('a', text: 'Settings').click
    assume_unchanged_screenshot "settings_page"
  end
end
