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
      if conversation
        fact_data_id = conversation.fact_data.id if conversation.fact_data
        Hashie::Mash.new({
          id: conversation.id,
          fact_data_id: fact_data_id
        })
      end
    end
  end
end
