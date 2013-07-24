require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversations_list.rb'

describe Queries::ConversationsList do
  include PavlovSupport

  let(:user){ double(id: 13) }

  before do
    stub_classes 'User', 'KillObject'
  end

  describe '#call' do
    it "returns a list when the user has conversations" do
      fact_data1 = double('fact_data', id: 100, fact_id: 124)
      fact_data2 = double('fact_data', id: 101, fact_id: 125)

      conversation1 = {id: 1, fact_data_id: fact_data1.id, recipient_ids: [1, 2, 13]}
      conversation2 = {id: 2, fact_data_id: fact_data2.id, recipient_ids: [1, 3, 13]}

      mock_conversations = [
        double('conversation', conversation1.merge(fact_data: fact_data1)),
        double('conversation', conversation2.merge(fact_data: fact_data2))
      ]
      criteria = double(:criteria)
      dead_conversations = [double, double]
      query = described_class.new(user_id: user.id.to_s,
        pavlov_options: { current_user: user })

      mock_conversations[0].should respond_to(:recipient_ids)
      User.should_receive(:find).with(user.id.to_s).and_return(user)
      user.should_receive(:conversations).and_return(criteria)
      criteria.should_receive(:desc).and_return(mock_conversations)
      KillObject.stub(:conversation).
        with(mock_conversations[0], fact_id: fact_data1.fact_id).
        and_return(dead_conversations[0])
      KillObject.stub(:conversation).
        with(mock_conversations[1], fact_id: fact_data2.fact_id).
        and_return(dead_conversations[1])

      expect(query.call).to eq(dead_conversations)
    end

    it "returns an empty list when the user has conversations" do
      criteria = double(:criteria)
      query = described_class.new(user_id: user.id.to_s, pavlov_options: { current_user: user })

      User.should_receive(:find).with(user.id.to_s).and_return(user)
      user.should_receive(:conversations).and_return(criteria)
      criteria.should_receive(:desc).and_return([])

      expect(query.call).to eq([])
    end
  end
end
