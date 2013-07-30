require 'pavlov'
require_relative '../kill_object'

module Queries
  class ConversationWithRecipientsAndMessages
    include Pavlov::Query

    arguments :id

    def execute
      conversation = old_query :conversation_get, id
      return nil unless conversation

      messages = old_query :messages_for_conversation, conversation
      recipients = old_query :users_by_ids, conversation.recipient_ids

      KillObject.conversation conversation, messages: messages, recipients: recipients
    end
  end
end
