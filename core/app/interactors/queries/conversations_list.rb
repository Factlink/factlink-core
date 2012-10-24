require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationsList
    include Pavlov::Query

    def execute
      User.find(@options[:current_user].id).conversations.map do |conversation|
        # TODO: eliminate implicit query in next line (retrieving fact_data)
        KillObject.conversation(conversation, fact_id: conversation.fact_data.andand.fact_id)
      end.reverse
    end

    def authorized?
      # Check if the current user exists
      @options[:current_user]
    end
  end
end
