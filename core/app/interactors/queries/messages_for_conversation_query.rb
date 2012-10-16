require 'hashie'

class MessagesForConversationQuery
  include Pavlov::Query
  include Pavlov::SmartInit

  arguments :conversation

  def execute
    Message.where(conversation_id: @conversation.id)
  end
end
