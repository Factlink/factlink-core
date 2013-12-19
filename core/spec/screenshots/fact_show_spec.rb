require 'screenshot_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include Screenshots::DiscussionHelper

  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    @user = sign_in_user create :full_user

    factlink = create_discussion

    5.times do
      factlink.add_opiniated :disbelieves, (create :user).graph_user
      factlink.add_opiniated :believes, (create :user).graph_user
      factlink.add_opiniated :doubts, (create :user).graph_user
    end

    factlink.add_opiniated :believes, (create :user).graph_user

    go_to_fact_show_of factlink

    page.should have_content factlink.data.displaystring

    find('.js-switch-to-factlink').click
    first('.js-sub-comments-link').click

    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the new discussion page is correct for an anonymous user" do
    @user = sign_in_user create :full_user
    factlink = create_discussion
    sign_out_user

    go_to_fact_show_of factlink
    first('a', text: '1 comment')

    page.should have_content factlink.data.displaystring

    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
