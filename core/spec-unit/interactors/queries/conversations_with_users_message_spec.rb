require 'pavlov_helper'
require_relative '../../../app/interactors/queries/conversations_with_users_message.rb'

describe Queries::ConversationsWithUsersMessage do
  include PavlovSupport

  before do
    stub_classes 'Queries::ConversationsList',
                 'Queries::UsersByIds',
                 'Queries::LastMessageForConversation'
  end

  describe '#call' do
    it 'should call the three other queries' do
      user1 = double(:user, id: 1)
      user2 = double(:user, id: 2)
      conversations = [
        double(:conversation, id: 10, recipient_ids: [1]),
        double(:conversation, id: 20, recipient_ids: [1, 2])
      ]
      message15 = double(:message, id: 15)
      message25 = double(:message, id: 25)

      pavlov_options = { current_user: user1 }
      query = described_class.new(user_id: user1.id.to_s,
        pavlov_options: pavlov_options)

      Pavlov.stub(:old_query)
           .with(:conversations_list, user1.id.to_s, pavlov_options)
           .and_return(conversations)
      Pavlov.stub(:old_query)
           .with(:last_message_for_conversation, conversations[0], pavlov_options)
          .and_return(message15)
      Pavlov.stub(:old_query)
           .with(:users_by_ids, [user1.id, user2.id], pavlov_options)
           .and_return([user1, user2])
      Pavlov.stub(:old_query)
           .with(:last_message_for_conversation, conversations[1], pavlov_options)
           .and_return(message25)

      result = query.call

      expect(result.length.should).to eq(2)

      conversation1 = result[0]
      conversation2 = result[1]

      expect(conversation1.id).to eq(conversations[0].id)
      expect(conversation2.id).to eq(conversations[1].id)

      expect(conversation1.recipients).to eq([user1])
      expect(conversation1.last_message).to eq(message15)
      expect(conversation2.recipients).to eq([user1, user2])
      expect(conversation2.last_message).to eq(message25)
    end
  end
end
