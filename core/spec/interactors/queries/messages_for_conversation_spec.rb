require File.expand_path('../../../../app/interactors/queries/messages_for_conversation.rb', __FILE__)
require 'hashie'

describe Queries::MessagesForConversation do
  before do
    stub_const 'Message', Class.new
  end

  it 'it throws when initialized without a argument' do
    expect { Queries::MessagesForConversation.new }.
      to raise_error(RuntimeError, 'wrong number of arguments.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::MessagesForConversation.new stub(id: 'g6')}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe '.execute' do
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

      messages = Queries::MessagesForConversation.execute(conversation, current_user: user)

      messages.should =~ message_hashes.map{|hash| Hashie::Mash.new(hash)}
    end
  end

end
