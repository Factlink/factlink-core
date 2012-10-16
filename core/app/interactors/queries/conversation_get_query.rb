require_relative 'query.rb'
require 'hashie'

class ConversationGetQuery
  include Query
  def initialize(id)
    @id = id
  end

  def execute
    conversation = Conversation.find(@id)
    conversation and Hashie::Mash.new({
      id: conversation.id,
      fact_data_id: conversation.fact_data_id
    })
  end
end
