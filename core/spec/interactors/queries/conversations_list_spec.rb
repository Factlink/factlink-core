require File.expand_path('../../../../app/interactors/queries/conversations_list.rb', __FILE__)

describe Queries::ConversationsList do
  let(:user)           {mock('user', id: 13)}

  before do
    stub_const 'User', Class.new
  end

  it 'it initializes correctly' do
    query = Queries::ConversationsList.new current_user: mock()
    query.should_not be_nil
  end

  describe '.execute' do
    it "returns a list when the user has conversations" do
      fact_data1 = mock('fact_data', id: 100, fact_id: 124)
      fact_data2 = mock('fact_data', id: 101, fact_id: 125)

      conversation1 = {id: 1, fact_data_id: fact_data1.id, recipient_ids: [1, 2, 13]}
      conversation2 = {id: 2, fact_data_id: fact_data2.id, recipient_ids: [1, 3, 13]}

      mock_conversations = [
        mock('conversation', conversation1.merge(fact_data: fact_data1)),
        mock('conversation', conversation2.merge(fact_data: fact_data2))
      ]

      mock_conversations[0].should respond_to(:recipient_ids)

      dead_conversations = [
        Hashie::Mash.new(conversation1.merge(fact_id: fact_data1.fact_id)),
        Hashie::Mash.new(conversation2.merge(fact_id: fact_data2.fact_id))
      ]

      criteria = mock(:criteria)

      User.should_receive(:find).with(user.id).and_return(user)
      user.should_receive(:conversations).and_return(criteria)
      criteria.should_receive(:desc).and_return(mock_conversations)

      result = Queries::ConversationsList.execute(current_user: user)
      expect(result).to eq(dead_conversations)
    end

    it "returns an empty list when the user has conversations" do
      criteria = mock(:criteria)
      User.should_receive(:find).with(user.id).and_return(user)
      user.should_receive(:conversations).and_return(criteria)
      criteria.should_receive(:desc).and_return([])

      result = Queries::ConversationsList.execute(current_user: user)
      expect(result).to eq([])
    end
  end
end
