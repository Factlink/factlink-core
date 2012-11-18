require File.expand_path('../../../../../app/interactors/queries/last_message_for_conversation.rb', __FILE__)

describe Queries::LastMessageForConversation do
  let(:empty_mongo_criteria) {mock('criteria', last: nil, first: nil)}
  let(:user)                 {mock('user', id: 13)}
  let(:conversation)         {mock('conversation', id: 14, recipient_ids: [13])}
  let(:message) do
    {id: 15, sender_id: 13, created_at: 'some time', updated_at: 'another time', content: 'blabla'}
  end

  before do
    stub_const "Message", Class.new
    stub_const "Pavlov::ValidationError", Class.new(StandardError)
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::LastMessageForConversation.new mock('conversation', id: 'g6'), current_user:mock()}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe ".authorized" do
    it 'works when the conversation contains the current user' do
      query = Queries::LastMessageForConversation.new mock('conversation', id: 1, recipient_ids: [13]), current_user: user
      query.should_not be_nil
    end

    it 'throws when the conversation does not contain the current user' do
      expect { Queries::LastMessageForConversation.new mock('conversation', id: 1, recipient_ids: [14]), current_user: user}.
        to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe ".execute" do
    it "works with a conversation that does not contain messages" do
      Message.should_receive(:where).with(conversation_id: conversation.id.to_s).and_return(empty_mongo_criteria)

      results = Queries::LastMessageForConversation.execute(conversation, current_user: user)
      expect(results).to eq(nil)
    end

    it "works with a conversation that contains multiple messages" do
      criteria = mock('criteria', last: mock('message', message))
      Message.should_receive(:where).with(conversation_id: conversation.id.to_s).and_return(criteria)

      results = Queries::LastMessageForConversation.execute(conversation, current_user: user)
      expect(results).to eq(OpenStruct.new(message))
    end
  end
end
