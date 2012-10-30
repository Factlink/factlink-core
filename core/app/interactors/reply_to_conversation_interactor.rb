require_relative 'pavlov'

class ReplyToConversationInteractor
  include Pavlov::Interactor

  arguments :conversation_id, :sender_id, :content

  def execute
    conversation = Conversation.find(@conversation_id)
    message = command :create_message, @sender_id, @content, conversation

    sender = User.find(@sender_id)
    command :create_activity, sender.graph_user, :replied_message, message, nil
  end
  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
