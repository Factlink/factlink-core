require 'screenshot_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include Screenshots::DiscussionHelper

  it "the layout of the discussion page is correct" do
    @user = sign_in_user create :full_user
    factlink = create_discussion

    go_to_discussion_page_of factlink
    first('a', text: '1 comment')

    page.should have_content factlink.data.displaystring
    sleep 2 # let the feed load behind the modal

    assume_unchanged_screenshot "discussion_page"
  end
end
