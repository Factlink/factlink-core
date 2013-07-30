require 'pavlov'

module Queries
  class LastMessageForConversation
    include Pavlov::Query

    arguments :conversation

    def validate
      validate_hexadecimal_string :id, @conversation.id.to_s
    end

    def execute
      message = Message.where(conversation_id: @conversation.id.to_s).last
      message and KillObject.message(message)
    end

    def authorized?
      pavlov_options[:current_user] and @conversation.recipient_ids.include? pavlov_options[:current_user].id
    end
  end
end
