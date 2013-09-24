require 'screenshot_helper'

describe "factlink", type: :feature do
  it "the layout of the profile page is correct" do
    user = sign_in_user create :active_user
    visit user_path(user)
    assume_unchanged_screenshot "profile_page"
  end

  it "the layout of the profile page is correct for deleted_users" do
    user = sign_in_user create :active_user, deleted: true
    visit user_path(user)
    assume_unchanged_screenshot "profile_page_deleted"
  end
end
