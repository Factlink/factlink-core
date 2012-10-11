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
      subject_type: conversation.subject.class,
      subject_id: conversation.subject.id
    })
  end
end