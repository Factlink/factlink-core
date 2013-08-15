require_relative '../kill_object'
require_relative '../../classes/hash_utils'

module Queries
  class ConversationsWithUsersMessage
    include Pavlov::Query

    arguments :user_id

    def execute
      conversations = query(:'conversations_list', user_id: user_id)
      users_by_id = all_recipients_by_ids(conversations)

      conversations.map do |conversation|
        last_message = query(:'last_message_for_conversation',
                                conversation: conversation)
        KillObject.conversation(conversation,
          recipients: conversation.recipient_ids.map {|id| users_by_id[id.to_s]},
          last_message: last_message
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
      ids = all_recipient_ids(conversations)
      query(:'users_by_ids', user_ids: ids)
    end

    def all_recipient_ids conversations
      conversations.flat_map {|c| c.recipient_ids}.uniq
    end
  end
end
