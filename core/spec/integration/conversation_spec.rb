require 'integration_helper'

describe "conversation", type: :request do
  include Acceptance::ConversationHelper
  include Acceptance::FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
    @recipients = [FactoryGirl.create(:approved_confirmed_user), FactoryGirl.create(:approved_confirmed_user)]
    sleep 5 # allow elasticsearch to index the users
  end

  it "message can be sent and viewed" do
    pending "Fails to often on CI"
    factlink = backend_create_fact
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    recipient_ids = Message.last.conversation.recipients.map {|r| r.id}

    @recipients.each do |recipient|
      expect(recipient_ids).to include recipient.id
      switch_to_user recipient
      open_message_with_content message_content
      page_should_have_factlink_and_message(message_content, factlink, recipient)
    end
  end

  it "a user should be able to reply to a message" do
    pending "Fails to often on CI"
    factlink = backend_create_fact
    message_content = 'content'

    send_message(message_content, factlink, @recipients)

    recipient_ids = Message.last.conversation.recipients.map {|r| r.id}

    @recipients.each do |recipient|
      expect(recipient_ids).to include recipient.id

      switch_to_user @user
      open_message_with_content message_content
      page_should_have_factlink_and_message(message_content, factlink, nil)
      last_message_should_have_content(message_content)

      message_content = FactoryGirl.generate(:content)
      send_reply(message_content)
      last_message_should_have_content(message_content)
    end
  end
end
