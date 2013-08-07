require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversation_get.rb'
require_relative '../../../app/interactors/kill_object'

describe Queries::ConversationGet do

  before do
    stub_const 'Conversation', Class.new
    stub_const 'Fact', Class.new
    stub_const 'FactData', Class.new
    stub_const 'Pavlov::ValidationError', Class.new(StandardError)
  end

  it 'it throws when initialized without a argument' do
    expect { described_class.new(id: '', pavlov_options: { current_user: double()}).call }.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  it 'it throws when initialized with a argument that is not a hexadecimal string' do
    expect { described_class.new(id: 'g6', pavlov_options: { current_user:double()}).call }.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe '#call' do
    it "returns the dead representation of the conversation if found" do
      id = 10
      fact_data = FactData.new
      recipient_ids = [10,13]
      fact_data.stub(id: 124, fact_id: 3445)
      double_conversation = double(id: id, fact_data_id: fact_data.id,
        fact_data: fact_data, recipient_ids: recipient_ids)

      user = double(id: 13)
      query = described_class.new(id: id, pavlov_options: { current_user: user })

      Conversation.should_receive(:find).with(id).and_return(double_conversation)

      result = query.call

      expect(result.id).to eq(id)
      expect(result.fact_data_id).to eq(fact_data.id)
      expect(result.fact_id).to eq(fact_data.fact_id)
      expect(result.recipient_ids).to eq(recipient_ids)
    end

    it "returns nil if no matching conversation is found" do
      query = described_class.new(id: 1245,
        pavlov_options: { current_user: double() })

      Conversation.stub find: nil

      expect(query.call).to be_nil
    end
  end
end
