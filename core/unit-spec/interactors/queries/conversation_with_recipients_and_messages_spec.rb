require 'pavlov_helper'
require File.expand_path('../../../../app/interactors/queries/conversation_with_recipients_and_messages.rb', __FILE__)

describe Queries::ConversationWithRecipientsAndMessages do
  include PavlovSupport
  
  before do
    stub_classes 'Queries::ConversationGet', 'Queries::MessagesForConversation', 'Queries::UsersByIds'
  end

  it "calls needed queries and returns it result" do
    recipient_ids = mock('recipient_ids')
    conversation = mock('conversation', id: 10, fact_id: 30, recipient_ids: recipient_ids)
    options = {current_user: mock()}
    query = Queries::ConversationWithRecipientsAndMessages.new(conversation.id, options)

    message_list = mock('list of messages')
    recipient_list = mock('list of recipients')


    should_receive_new_with_and_receive_execute(
      Queries::ConversationGet, conversation.id, options).and_return(conversation)

    should_receive_new_with_and_receive_execute(
      Queries::MessagesForConversation, conversation, options).and_return(message_list)

    should_receive_new_with_and_receive_execute(
      Queries::UsersByIds, recipient_ids, options).and_return(recipient_list)


    new_conversation = mock()
    KillObject.should_receive(:conversation).with(conversation, messages: message_list, recipients: recipient_list).
               and_return(new_conversation)
    result = query.execute

    expect(result).to eq(new_conversation)
  end

  it "returns nil if the conversation is not found" do
    options = {current_user: mock()}
    nonexistingid = mock()
    query = Queries::ConversationWithRecipientsAndMessages.new(nonexistingid, options)

    should_receive_new_with_and_receive_execute(
      Queries::ConversationGet, nonexistingid, options).and_return(nil)

    result = query.execute

    expect(result).to be_nil

  end
end
