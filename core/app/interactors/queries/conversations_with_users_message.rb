require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationsWithUsersMessage
    include Pavlov::Query

    def execute
      conversations = query :conversations_list
      users_by_id = all_recipients_by_ids(conversations)
      # TODO: clean this up by using a new dead object
      # Also, query only once for all last_messages (difficult because we need to use a mongo groupby)
      conversations.each do |conversation|
        conversation.recipients = conversation.recipient_ids.map {|id| users_by_id[id]}
        conversation.last_message = query :last_message_for_conversation, conversation
      end
    end

    def all_recipients_by_ids(conversations)
      wrap_with_ids(users_for_conversations(conversations))
    end

    def wrap_with_ids(array)
      array.each_with_object({}) {|u, hash| hash[u.id] = u}
    end

    def users_for_conversations(conversations)
      query :users_by_ids, all_recipient_ids(conversations)
    end

    def all_recipient_ids conversations
      conversations.flat_map {|c| c.recipient_ids}.uniq
    end

    def authorized?
      @options[:current_user]
    end
  end
end
