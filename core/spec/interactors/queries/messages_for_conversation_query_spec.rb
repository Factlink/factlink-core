require File.expand_path('../../../../app/interactors/queries/messages_for_conversation_query.rb', __FILE__)

describe MessagesForConversationQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Message', fake_class
  end

  it "retrieves dead representations of the messages belonging to the conversation" do
    conversation = double()
    conversation.stub(id: 10)
    conversation.stub(message_ids: [0, 1, 2, 3, 4])

    m = []
    (0..4).each do |i|
      m[i] = double()
      m[i].stub(id: i, created_at: i*1000, updated_at: i*2000, content: "message-#{i}", sender_id: i*500, conversation_id: 10)
    end

    Message.should_receive(:where).with(conversation_id: 10).and_return(m)
    messages = MessagesForConversationQuery.execute(conversation)

    (0..4).each do |i|
      expect(messages[i].id).to eq(m[i].id)
      expect(messages[i].created_at).to eq(m[i].created_at)
      expect(messages[i].updated_at).to eq(m[i].updated_at)
      expect(messages[i].content).to eq(m[i].content)
      expect(messages[i].sender_id).to eq(m[i].sender_id)
    end
  end

end
