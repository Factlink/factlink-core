require 'pavlov_helper'
require_relative '../../../app/interactors/queries/last_message_for_conversation.rb'

describe Queries::LastMessageForConversation do
  include PavlovSupport

  let(:empty_mongo_criteria) { double('criteria', last: nil, first: nil) }
  let(:user)                 { double('user', id: 13) }
  let(:conversation)         { double('conversation', id: 14, recipient_ids: [13]) }
  let(:message) do
    {id: 15, sender_id: 13, created_at: 'some time', updated_at: 'another time', content: 'blabla'}
  end

  before do
    stub_classes "Message", "KillObject"
  end

  describe "#authorized?" do
    it 'throws when the conversation does not contain the current user' do
      expect do
        pavlov_options = { current_user: user }
        query = described_class.new conversation: double(id: 1, recipient_ids: [14]), pavlov_options: pavlov_options
        query.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#call' do
    it "works with a conversation that does not contain messages" do
      query = described_class.new(conversation: conversation,
                                  pavlov_options: { current_user: user })

      Message.should_receive(:where).with(conversation_id: conversation.id.to_s).and_return(empty_mongo_criteria)

      results = query.call

      expect(results).to eq(nil)
    end

    it "works with a conversation that contains multiple messages" do
      query = described_class.new(conversation: conversation,
                                  pavlov_options: { current_user: user })
      dead_message = double
      criteria = double('criteria', last: double('message', message))

      Message.stub(:where)
        .with(conversation_id: conversation.id.to_s)
        .and_return(criteria)
      KillObject.stub(:message)
        .with(criteria.last)
        .and_return(dead_message)

      results = query.call

      expect(results).to eq(dead_message)
    end
  end
end
