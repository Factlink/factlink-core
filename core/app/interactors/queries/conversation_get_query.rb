class ConversationGetQuery
  include Pavlov::Query

  arguments :id

  def execute
    conversation = Conversation.find(@id)
    conversation and conversation.subject and Hashie::Mash.new({
      id: conversation.id,
      subject_type: conversation.subject.class,
      subject_id: conversation.subject.id
    })
  end
end
