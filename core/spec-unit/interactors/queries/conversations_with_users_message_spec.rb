require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversations_with_users_message.rb'

describe Queries::ConversationsWithUsersMessage do
  include PavlovSupport

  let(:user1)          {mock('user', id: 1)}
  let(:user2)          {mock('user', id: 2)}
  let(:conversation10) {mock('conversation', id: 10, recipient_ids: [1])}
  let(:conversation20) {mock('conversation', id: 20, recipient_ids: [1, 2])}
  let(:conversations)  {[conversation10, conversation20]}
  let(:message15)      {mock('message', id: 15)}
  let(:message25)      {mock('message', id: 25)}

  before do
    stub_const('Queries::ConversationsList', Class.new)
    stub_const('Queries::UsersByIds', Class.new)
    stub_const('Queries::LastMessageForConversation', Class.new)
  end

  it 'should initialize' do
    query = Queries::ConversationsWithUsersMessage.new(user1.id.to_s, current_user: user1)
    query.should_not be_nil
  end

  describe ".all_recipient_ids" do
    it "should work with overlapping ids" do
      query = Queries::ConversationsWithUsersMessage.new(user1.id.to_s, current_user: user1)
      result = query.all_recipient_ids([conversation10, conversation20])
      expect(result).to eq([1, 2])
    end
  end

  describe :all_recipients_by_ids do
    it "should return the recipients indexed by id's" do
      mocklist = [
        mock('foo', id: 1),
        mock('bar', id: 2)
      ]
      querylist = mock()
      query = Queries::ConversationsWithUsersMessage.new(user1.id.to_s, current_user: user1)

      query.should_receive(:users_for_conversations).with(querylist).and_return(mocklist)

      result = query.all_recipients_by_ids(querylist)
      expect(result).to eq({
        mocklist[0].id.to_s => mocklist[0],
        mocklist[1].id.to_s => mocklist[1]
      })
    end
  end

  describe :wrap_with_ids do
    it "wraps its input in a hash, with as index the id of the objects in the array" do
      mocklist = mock
      wrapped_mock_list = mock

      query = Queries::ConversationsWithUsersMessage.new(mock, current_user: mock)
      HashUtils.should_receive(:hash_with_index).with(:id, mocklist).and_return(wrapped_mock_list)

      expect(query.wrap_with_ids(mocklist)).to eq wrapped_mock_list
    end
  end

  describe :users_for_conversations do
    it 'retrieves users user UsersByIds' do
      conversations = [mock('foo', recipient_ids: [1,2]),mock('foo', recipient_ids: [2,3,4])]
      users = mock()
      query = Queries::ConversationsWithUsersMessage.new(user1.id.to_s, current_user: user1)
      query.should_receive(:query).with(:users_by_ids, [1,2,3,4]).
        and_return(users)

      result = query.users_for_conversations(conversations)

      expect(result).to eq(users)
    end
  end

  describe ".call" do
    it "should call the three other queries" do
      query = Queries::ConversationsWithUsersMessage.new(user1.id.to_s, current_user: user1)

      query.should_receive(:query).with(:conversations_list, user1.id.to_s).
        and_return(conversations)
      query.should_receive(:all_recipients_by_ids).with([conversation10, conversation20]).and_return(1 => user1, 2 => user2)
      query.should_receive(:query).with(:last_message_for_conversation, conversation10).
        and_return(message15)
      query.should_receive(:query).with(:last_message_for_conversation, conversation20).
        and_return(message25)

      result = query.call
      expect(result.length.should).to eq(2)

      conversation1 = result[0]
      conversation2 = result[1]

      expect(conversation1.id).to eq(conversation10.id)
      expect(conversation2.id).to eq(conversation20.id)

      expect(conversation1.recipients).to eq([user1])
      expect(conversation1.last_message).to eq(message15)
      expect(conversation2.recipients).to eq([user1, user2])
      expect(conversation2.last_message).to eq(message25)
    end
  end
end
