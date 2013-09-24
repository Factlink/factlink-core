require 'screenshot_helper'

describe "factlink", type: :feature do
  before :each do
    user1 = sign_in_user create :full_user
    user2 = create :full_user
    user3 = create :full_user
    user4 = create :full_user

    Timecop.freeze Time.local(1989, 11, 6, 11, 22, 33)

    user1.admin = true
    user1.current_sign_in_at = Time.now.utc
    user1.save

    Timecop.return
  end

  it "the layout of the admin page is correct" do
    visit admin_users_path
    assume_unchanged_screenshot "admin_page"
  end
end
