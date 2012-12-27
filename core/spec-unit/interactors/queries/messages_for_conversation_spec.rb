require 'pavlov_helper'
require_relative '../../../app/interactors/queries/messages_for_conversation.rb'

describe Queries::MessagesForConversation do
  include PavlovSupport

  before do
    stub_classes 'Message'
  end

  it 'it throws when initialized without a argument' do
    expect { Queries::MessagesForConversation.new }.
      to raise_error(RuntimeError, 'wrong number of arguments.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::MessagesForConversation.new stub(id: 'g6')}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe '.call' do
    it 'retrieves dead representations of the messages belonging to the conversation' do
      user = mock()
      user.stub(id:11)

      conversation = stub id: 10, recipient_ids: [11]

      message_ids = [0, 1, 2, 3, 4]

      message_hashes = message_ids.map do |i|
        {id: i, created_at: i*1000, updated_at: i*2000, content: "message-#{i}", sender_id: i*500}
      end


      Message.should_receive(:where).with(conversation_id: conversation.id).
              and_return(message_hashes.map{|hash| stub(hash)})

      messages = Queries::MessagesForConversation.new(conversation, current_user: user).call

      messages.should =~ message_hashes.map{|hash| OpenStruct.new(hash)}
    end
  end

end
