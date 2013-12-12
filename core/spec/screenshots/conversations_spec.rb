require 'screenshot_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
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

  it "the layout of the conversations detail page is correct" do
    factlink = backend_create_fact
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    recipient_ids = Message.last.conversation.recipients.map(&:id)

    @recipients.each do |recipient|
      expect(recipient_ids).to include recipient.id

      switch_to_user @user
      open_message_with_content message_content
    end

    assume_unchanged_screenshot "conversations_detail"
  end
end
