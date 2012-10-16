require 'hashie'

class MessagesForConversationQuery
  include Pavlov::Query
  include Pavlov::SmartInit

  arguments :conversation

  def execute
    Message.where(conversation_id: @conversation.id).map do |message|
      Hashie::Mash.new({
        id: message.id,
        created_at: message.created_at,
        updated_at: message.updated_at,
        content: message.content,
        sender_id: message.sender_id
      })
    end
  end
end
