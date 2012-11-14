require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationsList
    include Pavlov::Query

    arguments :user_id

    def execute
      User.find(@user_id).conversations.desc(:updated_at).map do |conversation|
        # TODO: eliminate implicit query in next line (retrieving fact_data)
        KillObject.conversation(conversation, fact_id: conversation.fact_data.andand.fact_id)
      end
    end

    def authorized?
      true
    end
  end
end
