require 'screenshot_helper'

describe "factlink", type: :request do
  before :each do
    Timecop.freeze Time.local(1989, 11, 6, 11, 22, 33)

    user1 = sign_in_user create :active_user
    user2 = create :active_user
    user3 = create :active_user
    user4 = create :active_user

    user1.admin = true
    user1.save
  end

  after do
    Timecop.return
  end

  it "the layout of the admin page is correct" do
    visit admin_users_path
    assume_unchanged_screenshot "admin_page"
  end
end
