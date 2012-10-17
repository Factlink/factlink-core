require File.expand_path('../../../../app/interactors/queries/messages_for_conversation_query.rb', __FILE__)

describe MessagesForConversationQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Conversation', fake_class
    stub_const 'Fact', fake_class
    stub_const 'Message', fake_class
  end

  describe '.execute' do
    it "retrieves dead representations of the messages belonging to the conversation" do
      conversation = mock()
      conversation.stub(id: 10)
      conversation.stub(message_ids: [1,2,3])
      m1 = mock()
      m2 = mock()
      m3 = mock()
      Message.should_receive(:where).with(conversation_id: 10).and_return([m1, m2, m3])

      messages = MessagesForConversationQuery.execute(conversation)

      messages.should =~ [m1,m2,m3]
    end
  end

end
