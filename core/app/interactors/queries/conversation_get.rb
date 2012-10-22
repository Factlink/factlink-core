require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationGet
    include Pavlov::Query

    arguments :id

    def validate
      raise 'id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match @id.to_s
    end

    def execute
      conversation = Conversation.find(@id)
      return nil unless conversation
      raise_unauthorized unless authorized_to_get(conversation)

      fact_data_id = conversation.fact_data.id if conversation.fact_data
      Hashie::Mash.new({
        id: conversation.id,
        fact_data_id: fact_data_id,
        recipient_ids: conversation.recipient_ids
      })
    end

    def authorized?
      # postpone check until we retrieved conversation, only require an initiating user
      @options[:current_user]
    end

    def authorized_to_get(conversation)
      conversation.recipient_ids.include? @options[:current_user].id
    end
  end
end
