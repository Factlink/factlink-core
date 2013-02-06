require 'screenshot_helper'

describe "factlink", type: :request do
  include Screenshots::DiscussionHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :active_user
  end

  it "the layout of the discussion page is correct" do
    @factlink = create_discussion

    go_to_fact_show_of @factlink
    find('a', text: 'Comments (1)').click

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "discussion_page"
  end
end
