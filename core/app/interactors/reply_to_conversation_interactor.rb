require_relative 'pavlov'

class ReplyToConversationInteractor
  include Pavlov::Interactor

  arguments :conversation_id, :sender_id, :content

  def execute
    sender = User.find(@sender_id)
    conversation = Conversation.find(@conversation_id)

    command :create_message, sender.id, @content, conversation
    command :create_activity, sender.graph_user, :replied_conversation, conversation
  end
  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
