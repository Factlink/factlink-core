require 'screenshot_helper'

describe "factlink", type: :request do
  include Screenshots::DiscussionHelper

  it "the layout of the discussion page is correct" do
    @user = sign_in_user FactoryGirl.create :active_user

    @factlink = create_discussion

    go_to_fact_show_of @factlink
    find('a', text: 'Comments (1)').click

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the discussion page is correct for a user acting_as_non_signed_in_user" do
    @user = sign_in_user FactoryGirl.create :active_user

    @factlink = create_discussion

    sign_out_user

    @user = sign_in_user FactoryGirl.create :acting_as_non_signed_in_user

    go_to_fact_show_of @factlink
    find('a', text: 'Comments (1)').click

    page.should have_content @factlink.data.displaystring

    screenshot_and_open_image
    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
