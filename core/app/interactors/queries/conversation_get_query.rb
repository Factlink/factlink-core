class ConversationGetQuery
  include Pavlov::Query

  arguments :id

  def execute
    conversation = Conversation.find(@id)
    conversation and Hashie::Mash.new({
      id: conversation.id,
      fact_data_id: conversation.fact_data_id
    })
  end
end
