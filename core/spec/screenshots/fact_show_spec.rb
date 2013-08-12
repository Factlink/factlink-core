require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper

  it "the layout of the discussion page is correct" do
    @user = sign_in_user create :active_user

    @factlink = create_discussion

    go_to_fact_show_of @factlink
    first('a', text: 'Comments (1)').click

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the new discussion page is correct with doubters on top" do
    @user = sign_in_user create :active_user
    enable_features(@user, :new_discussion_page)

    factlink = create_discussion

    factlink.add_opiniated :believes, (create :user).graph_user

    10.times do
      factlink.add_opiniated :doubts, (create :user).graph_user
    end

    FactGraph.recalculate

    go_to_fact_show_of factlink

    page.should have_content factlink.data.displaystring

    assume_unchanged_screenshot "new_fact_show_A"
  end

  it "the layout of the new discussion page is correct with believers on top" do
    @user = sign_in_user create :active_user
    enable_features(@user, :new_discussion_page)

    factlink = create_discussion

    5.times do
      factlink.add_opiniated :disbelieves, (create :user).graph_user
      factlink.add_opiniated :believes, (create :user).graph_user
      factlink.add_opiniated :doubts, (create :user).graph_user
    end

    factlink.add_opiniated :believes, (create :user).graph_user

    FactGraph.recalculate

    go_to_fact_show_of factlink

    page.should have_content factlink.data.displaystring

    assume_unchanged_screenshot "new_fact_show_B"
  end


  it "the layout of the discussion page is correct for an anonymous user" do
    @user = sign_in_user create :active_user

    @factlink = create_discussion

    sign_out_user

    go_to_fact_show_of @factlink
    first('a', text: 'Comments (1)').click

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
