require 'pavlov_helper'
require_relative '../../../app/interactors/queries/messages_for_conversation.rb'
require_relative '../../../app/interactors/kill_object'


describe Queries::MessagesForConversation do
  include PavlovSupport

  before do
    stub_classes 'Message'
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect_validating(conversation: double(id: 'g6'))
      .to fail_validation 'id should be an hexadecimal string.'
  end

  describe '#call' do
    it 'retrieves dead representations of the messages belonging to the conversation' do
      user_id = 11
      options = { current_user: double(id: user_id) }
      conversation = double(id: 10, recipient_ids: [user_id])
      message_ids = [0, 1, 2, 3, 4]
      message_hashes = message_ids.map do |i|
        {
          dead_object_name: :message,
          id: i,
          created_at: i*1000,
          updated_at: i*2000,
          content: "message-#{i}",
          sender_id: i*500
        }
      end
      query = described_class.new(conversation: conversation,
        pavlov_options: options)

      Message.should_receive(:where).with(conversation_id: conversation.id).
              and_return(message_hashes.map{|hash| double(hash)})

      messages = query.call

      messages.should =~ message_hashes.map{|hash| OpenStruct.new(hash)}
    end
  end
end
