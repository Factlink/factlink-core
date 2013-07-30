require 'pavlov'

module Queries
  class MessagesForConversation
    include Pavlov::Query

    arguments :conversation

    def execute
      messages = Message.where(conversation_id: @conversation.id)
      messages.map { |message| KillObject.message message }
    end

    def validate
      validate_hexadecimal_string :id, @conversation.id.to_s
    end

    def authorized?
      pavlov_options[:current_user] and
      @conversation.recipient_ids.include? pavlov_options[:current_user].id
    end
  end
end
