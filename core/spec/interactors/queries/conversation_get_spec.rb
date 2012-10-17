require File.expand_path('../../../../app/interactors/queries/conversation_get.rb', __FILE__)

describe Queries::ConversationGet do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Conversation', fake_class
    stub_const 'FactData', fake_class
  end

  it 'it initializes correctly' do
    query = Queries::ConversationGet.new 1
    query.should_not be_nil
  end

  it 'it throws when initialized without a argument' do
    expect { Queries::ConversationGet.new }.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::ConversationGet.new 'g6'}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe '.execute' do
    it "returns the dead representation of the conversation if found" do
      id = 10
      fact_data = FactData.new
      fact_data.stub(id: 124)
      mock_conversation = mock()
      mock_conversation.stub id: id, fact_data: fact_data

      Conversation.should_receive(:find).with(id).and_return(mock_conversation)
      res = Queries::ConversationGet.execute(id)

      expect(res.id).to eq(id)
      expect(res.fact_data_id).to eq(fact_data.id)
    end

    it "returns nil if no matching conversation is found" do
      Conversation.should_receive(:find).and_return(nil)

      res = Queries::ConversationGet.execute(1245)

      expect(res).to be_nil
    end
  end
end
