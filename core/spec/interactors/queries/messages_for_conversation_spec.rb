require File.expand_path('../../../../app/interactors/queries/messages_for_conversation.rb', __FILE__)
require 'hashie'

describe Queries::MessagesForConversation do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Message', fake_class
  end

  it 'it initializes correctly' do
    query = Queries::MessagesForConversation.new 1
    query.should_not be_nil
  end

  it 'it throws when initialized without a argument' do
    expect { Queries::MessagesForConversation.new }.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::MessagesForConversation.new 'g6'}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe '.execute' do
    it 'retrieves dead representations of the messages belonging to the conversation' do
      conversation_id = 10
      message_ids = [0, 1, 2, 3, 4]

      message_hashes = message_ids.map do |i|
        {id: i, created_at: i*1000, updated_at: i*2000, content: "message-#{i}", sender_id: i*500}
      end

      Message.should_receive(:where).with(conversation_id: conversation_id).and_return(message_hashes.map{|hash| stub(hash)})

      messages = Queries::MessagesForConversation.execute(conversation_id)

      messages.should =~ message_hashes.map{|hash| Hashie::Mash.new(hash)}
    end
  end

end
