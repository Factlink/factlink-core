require File.expand_path('../../../../app/interactors/queries/conversations_with_users_message.rb', __FILE__)
require_relative '../interactor_spec_helper'

describe Queries::ConversationsWithUsersMessage do
  let(:user1)          {mock('user', id: 1)}
  let(:user2)          {mock('user', id: 2)}
  let(:conversation10) {mock('conversation', id: 10, last_message: nil, recipients: nil)}
  let(:conversation20) {mock('conversation', id: 20, last_message: nil, recipients: nil)}
  let(:conversations)  {[conversation10, conversation20]}
  let(:message15)      {mock('message', id: 15)}
  let(:message25)      {mock('message', id: 25)}

  before do
    stub_const('Queries::ConversationsList', Class.new)
    stub_const('Queries::UsersForConversations', Class.new)
    stub_const('Queries::LastMessageForConversation', Class.new)
  end

  it 'should initialize' do
    query = Queries::ConversationsWithUsersMessage.new(current_user: user1)
    query.should_not be_nil
  end

  describe ".execute" do
    it "should call the three other queries" do
      should_receive_new_with_and_receive_execute(Queries::ConversationsList, current_user: user1).
        and_return(conversations)
      should_receive_new_with_and_receive_execute(Queries::UsersForConversations, conversations, current_user: user1).
        and_return(10 => [user1], 20 => [user1, user2])
      should_receive_new_with_and_receive_execute(Queries::LastMessageForConversation, conversation10, current_user: user1).
        and_return(message15)
      should_receive_new_with_and_receive_execute(Queries::LastMessageForConversation, conversation20, current_user: user1).
        and_return(message25)
      conversation10.should_receive(:recipients=).with([user1])
      conversation10.should_receive(:last_message=).with(message15)
      conversation20.should_receive(:recipients=).with([user1, user2])
      conversation20.should_receive(:last_message=).with(message25)

      result = Queries::ConversationsWithUsersMessage.execute(current_user: user1)
    end
  end
end
