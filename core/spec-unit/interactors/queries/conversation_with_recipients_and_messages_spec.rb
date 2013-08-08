require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversation_with_recipients_and_messages.rb'

describe Queries::ConversationWithRecipientsAndMessages do
  include PavlovSupport

  before do
    stub_classes 'Queries::ConversationGet', 'Queries::MessagesForConversation', 'Queries::UsersByIds'
  end

  it 'calls needed queries and returns it result' do
    recipient_ids = double('recipient_ids')
    conversation = double('conversation', id: 10, fact_id: 30, recipient_ids: recipient_ids)
    options = {current_user: double()}
    message_list = double('list of messages')
    recipient_list = double('list of recipients')
    query = described_class.new(id: conversation.id, pavlov_options: options)
    new_conversation = double()

    Pavlov.stub(:old_query)
      .with(:conversation_get, conversation.id, options)
      .and_return(conversation)
    Pavlov.stub(:old_query)
      .with(:messages_for_conversation, conversation, options)
      .and_return(message_list)
    Pavlov.stub(:old_query)
      .with(:users_by_ids, recipient_ids, options)
      .and_return(recipient_list)
    KillObject.stub(:conversation)
      .with(conversation, messages: message_list, recipients: recipient_list)
      .and_return(new_conversation)

    result = query.call

    expect(result).to eq(new_conversation)
  end

  it 'returns nil if the conversation is not found' do
    options = {current_user: double()}
    nonexistingid = double()
    query = described_class.new(id: nonexistingid, pavlov_options: options)

    Pavlov.stub(:old_query)
      .with(:conversation_get, nonexistingid, options)
      .and_return(nil)

    expect(query.call).to be_nil
  end
end
