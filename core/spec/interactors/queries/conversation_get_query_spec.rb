require File.expand_path('../../../../app/interactors/queries/conversation_get_query.rb', __FILE__)

describe ConversationGetQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Conversation', fake_class
    stub_const 'Fact', fake_class
  end

  it "returns the dead representation of the conversation if found" do
    id = 10
    subject = Fact.new
    subject.stub(id: 124)
    mock_conversation = mock()
    mock_conversation.stub id: id, subject: subject

    Conversation.should_receive(:find).with(id).and_return(mock_conversation)
    res = ConversationGetQuery.execute(id)

    expect(res.id).to eq(id)
    expect(res.subject_type).to eq(subject.class)
    expect(res.subject_id).to eq(subject.id)
  end

  it "returns nil if no matching conversation is found" do
    Conversation.should_receive(:find).and_return(nil)

    res = ConversationGetQuery.execute(1245)

    expect(res).to be_nil
  end

end
