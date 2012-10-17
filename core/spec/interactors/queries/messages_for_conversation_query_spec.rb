require File.expand_path('../../../../app/interactors/queries/messages_for_conversation_query.rb', __FILE__)
require 'hashie'

describe MessagesForConversationQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Message', fake_class
  end

  describe '.execute' do
    it "retrieves dead representations of the messages belonging to the conversation" do
      message_ids = [0, 1, 2, 3, 4]

      conversation = mock()
      conversation.stub(id: 10)
      conversation.stub(message_ids: message_ids)

      message_hashes = [0, 1, 2, 3, 4].map do |i|
        {id: i, created_at: i*1000, updated_at: i*2000, content: "message-#{i}", sender_id: i*500}
      end

      Message.should_receive(:where).with(conversation_id: 10).and_return(message_hashes.map{|hash| stub(hash)})

      messages = MessagesForConversationQuery.execute(conversation)

      messages.should =~ message_hashes.map{|hash| Hashie::Mash.new(hash)}
    end
  end

end
