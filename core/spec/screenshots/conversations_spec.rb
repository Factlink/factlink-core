require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper

  it "the layout of the conversations overview page is correct" do
    @user = sign_in_user create :full_user
    factlink = create_discussion

    go_to_discussion_page_of factlink

    within '.top-fact' do
      click_on "Share"
    end

    within '.start-conversation' do
      recipients.each {|r| add_recipient r.name}
      find(:css, 'textarea').click
      sleep 0.1
      find(:css, 'textarea').set(message)

      click_button 'Send'
    end

    visit "/m"

    assume_unchanged_screenshot "conversations_overview"
  end
end
