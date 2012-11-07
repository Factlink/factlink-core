require File.expand_path('../../../../app/interactors/queries/conversation_get.rb', __FILE__)

describe Queries::ConversationGet do

  before do
    stub_const 'Conversation', Class.new
    stub_const 'Fact', Class.new
    stub_const 'FactData', Class.new
  end

  it 'it initializes correctly' do
    query = Queries::ConversationGet.new 1, current_user: mock()
    query.should_not be_nil
  end

  it 'it throws when initialized without a argument' do
    expect { Queries::ConversationGet.new '', current_user: mock() }.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::ConversationGet.new 'g6', current_user:mock()}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe '.execute' do
    it "returns the dead representation of the conversation if found" do
      id = 10
      fact_data = FactData.new
      recipient_ids = [10,13]
      fact_data.stub(id: 124, fact_id: 3445)
      mock_conversation = mock()
      mock_conversation.stub id: id, fact_data_id: fact_data.id, fact_data: fact_data, recipient_ids: recipient_ids

      user = mock()
      user.stub(id: 13)

      Conversation.should_receive(:find).with(id).and_return(mock_conversation)
      res = Queries::ConversationGet.execute(id, current_user: user)

      expect(res.id).to eq(id)
      expect(res.fact_data_id).to eq(fact_data.id)
      expect(res.fact_id).to eq(fact_data.fact_id)
      expect(res.recipient_ids).to eq(recipient_ids)
    end

    it "returns nil if no matching conversation is found" do
      Conversation.should_receive(:find).and_return(nil)

      res = Queries::ConversationGet.execute(1245, current_user: mock())

      expect(res).to be_nil
    end
  end
end
