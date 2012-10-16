class ConversationGetQuery
  include Pavlov::Query

  arguments :id

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
