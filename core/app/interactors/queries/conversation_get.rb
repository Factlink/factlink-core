require 'andand'

module Queries
  class ConversationGet
    include Pavlov::Query

    arguments :id

    def validate
      validate_hexadecimal_string :id, id.to_s
    end

    def execute
      conversation = Conversation.find(id)
      return nil unless conversation
      raise_unauthorized unless authorized_to_get(conversation)

      fact_data = conversation.fact_data

      KillObject.conversation conversation,
        fact_id: fact_data && fact_data.fact_id
    end

    def authorized?
      # postpone check until we retrieved conversation, only require an initiating user
      pavlov_options[:current_user]
    end

    def authorized_to_get(conversation)
      conversation.recipient_ids.include? pavlov_options[:current_user].id
    end
  end
end
