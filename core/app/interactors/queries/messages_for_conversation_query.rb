require_relative 'query.rb'
require 'hashie'

class MessagesForConversationQuery
  include Query
  def initialize(conversation)
    @conversation = conversation
  end
  def execute
    Message.where(conversation_id: @conversation.id)
  end
end
