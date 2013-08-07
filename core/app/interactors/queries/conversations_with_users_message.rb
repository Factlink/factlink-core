require_relative '../kill_object'
require_relative '../../classes/hash_utils'

module Queries
  class ConversationsWithUsersMessage
    include Pavlov::Query

    arguments :user_id

    def execute
      conversations = old_query :conversations_list, user_id
      users_by_id = all_recipients_by_ids(conversations)

      conversations.map do |conversation|
        KillObject.conversation(conversation,
          recipients: conversation.recipient_ids.map {|id| users_by_id[id.to_s]},
          last_message: (old_query :last_message_for_conversation, conversation)
        )
      end
    end

    def all_recipients_by_ids(conversations)
      wrap_with_ids(users_for_conversations(conversations))
    end

    def wrap_with_ids(array)
      HashUtils.hash_with_index(:id, array)
    end

    def users_for_conversations(conversations)
      old_query :users_by_ids, all_recipient_ids(conversations)
    end

    def all_recipient_ids conversations
      conversations.flat_map {|c| c.recipient_ids}.uniq
    end
  end
end
