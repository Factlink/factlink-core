require_relative '../pavlov'
require 'hashie'

module Queries
  class ConversationsList
    include Pavlov::Query

    def execute
      User.find(@options[:current_user].id).conversations.map do |conversation|
        Hashie::Mash.new({
          id: conversation.id,
          fact_data_id: conversation.fact_data_id,
          recipient_ids: conversation.recipient_ids
        })
      end
    end

    def authorized?
      # Check if the current user exists
      @options[:current_user]
    end
  end
end
