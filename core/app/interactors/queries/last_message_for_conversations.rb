require_relative '../pavlov'
require 'hashie'

module Queries
  class LastMessageForConversations
    include Pavlov::Query

    arguments :conversations

    def validate
      @conversations.each do |conversation|
        raise 'id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match conversation.id.to_s
      end
    end

    def execute
      # TODO: improve performance by just doing one big request instead of a lot of small ones
      @conversations.each do |conversation|
        conversation.last_message = message_hash(Message.where(conversation_id: conversation.id.to_s).last)
      end
    end

    def authorized?
      @options[:current_user] and
      @conversations.each do |conversation|
        conversation.recipient_ids.include? @options[:current_user].id
      end
    end

    private
    def message_hash(message)
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
