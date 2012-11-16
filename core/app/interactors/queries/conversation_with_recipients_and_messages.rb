require_relative '../pavlov'
require_relative '../kill_object'

module Queries
  class ConversationWithRecipientsAndMessages
    include Pavlov::Query

    arguments :id
    def execute
      conversation = query :conversation_get, @id
      return nil unless conversation

      messages = query :messages_for_conversation, conversation
      recipients = query :users_by_ids, conversation.recipient_ids

      KillObject.conversation conversation, messages: messages, recipients: recipients
    end
  end
end
