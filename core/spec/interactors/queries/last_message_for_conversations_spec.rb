require File.expand_path('../../../../app/interactors/queries/last_message_for_conversations.rb', __FILE__)
require 'hashie'

describe Queries::LastMessageForConversations do
  let(:empty_mongo_criteria) do
    mock('criteria', last: nil, first: nil)
  end

  before do
    stub_const "Message", Class.new
  end

  describe ".execute" do
    it "works with an empty list of conversations" do
      query = Queries::LastMessageForConversations.new([], current_user: mock())
      query.execute.should =~ []
    end
    it "sets last_message to nil when the conversation has no messages" do
      current_user = mock('user', id: 13)
      conversation = mock('conversation', id: 14, recipient_ids: [current_user.id])
      Message.should_receive(:where).with(conversation_id: conversation.id.to_s).and_return(empty_mongo_criteria)

      conversation.should_receive(:last_message=).with(nil)

      results = Queries::LastMessageForConversations.execute([conversation], current_user: current_user)
      results.should =~ [conversation]
    end
  end
end
