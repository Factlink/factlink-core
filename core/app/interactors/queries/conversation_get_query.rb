require_relative '../pavlov'
require 'hashie'

class ConversationGetQuery
  include Pavlov::Query

  arguments :id

  def validate
    raise 'id should be an integer.' unless /\A\d+\Z/.match @id
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
