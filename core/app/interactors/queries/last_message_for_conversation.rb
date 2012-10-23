require_relative '../pavlov'
require 'hashie'

module Queries
  class LastMessageForConversation
    include Pavlov::Query

    arguments :conversation

    def validate
      raise 'id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match @conversation.id.to_s
    end

    def execute
      message = Message.where(conversation_id: @conversation.id.to_s).last
      message and message_dead(message)
    end

    def authorized?
      @options[:current_user] and @conversation.recipient_ids.include? @options[:current_user].id
    end

    private
    def message_dead(message)
      Hashie::Mash.new(
        id: message.id,
        created_at: message.created_at,
        updated_at: message.updated_at,
        content: message.content,
        sender_id: message.sender_id
      )
    end
  end
end
