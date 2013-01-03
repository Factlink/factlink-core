require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversation_with_recipients_and_messages.rb'

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


    query.should_receive(:query).with(:conversation_get, conversation.id).and_return(conversation)

    query.should_receive(:query).with(:messages_for_conversation, conversation).and_return(message_list)

    query.should_receive(:query).with(:users_by_ids, recipient_ids).and_return(recipient_list)


    new_conversation = mock()
    KillObject.should_receive(:conversation).with(conversation, messages: message_list, recipients: recipient_list).
               and_return(new_conversation)
    result = query.call

    expect(result).to eq(new_conversation)
  end

  it "returns nil if the conversation is not found" do
    options = {current_user: mock()}
    nonexistingid = mock()
    query = Queries::ConversationWithRecipientsAndMessages.new(nonexistingid, options)

    query.should_receive(:query).with(:conversation_get, nonexistingid).and_return(nil)

    result = query.call

    expect(result).to be_nil

  end
end
