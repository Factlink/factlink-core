require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationsWithUsersMessage
    include Pavlov::Query

    def execute
      conversations = query :conversations_list
      recipients_by_conversation_id = query :users_for_conversations, conversations

      # TODO: clean this up by using a new dead object
      conversations.each do |conversation|
        conversation.recipients = recipients_by_conversation_id[conversation.id]
        conversation.last_message = query :last_message_for_conversation, conversation
      end
    end

    def authorized?
      @options[:current_user]
    end
  end
end
