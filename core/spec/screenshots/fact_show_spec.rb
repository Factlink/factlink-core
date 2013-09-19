require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper

  it "the layout of the new discussion page is correct with doubters on top, and
      adding weakening comment" do
    @user = sign_in_user create :active_user

    factlink = create_discussion

    factlink.add_opiniated :believes, (create :user).graph_user

    10.times do
      factlink.add_opiniated :doubts, (create :user).graph_user
    end

    FactGraph.recalculate

    go_to_fact_show_of factlink

    page.should have_content factlink.data.displaystring

    find('.js-weakening-button').click

    assume_unchanged_screenshot "fact_show_A"
  end

  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    @user = sign_in_user create :active_user

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

    find('.js-supporting-button').click
    find('.js-switch-to-factlink').click

    assume_unchanged_screenshot "fact_show_B"
  end

  it "the layout of the new discussion page is correct for an anonymous user" do

    @user = sign_in_user create :active_user
    factlink = create_discussion
    sign_out_user

    go_to_fact_show_of factlink
    find('.evidence-box', text: 'Fact 1').find('a', text:'1 comment')

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
