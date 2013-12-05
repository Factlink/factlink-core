require 'screenshot_helper'

describe "factlink", type: :feature do
  include Acceptance::ConversationHelper
  include Acceptance::FactHelper

  before :each do
    @user = sign_in_user(create :full_user, :confirmed)
    @recipients = create_list :full_user, 2
  end

  it "the layout of the conversations overview page is correct" do
    factlink = backend_create_fact
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    visit "/m"

    assume_unchanged_screenshot "conversations_overview"
  end
end
