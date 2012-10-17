require_relative '../pavlov'
require 'hashie'

module Queries
  class MessagesForConversation
    include Pavlov::Query

    arguments :id

    def validate
      raise 'id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match @id.to_s
    end

    def execute
      Message.where(conversation_id: @id).map do |message|
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
end
