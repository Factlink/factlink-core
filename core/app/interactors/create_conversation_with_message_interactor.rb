require_relative 'pavlov'

class CreateConversationWithMessageInteractor
  include Pavlov::Interactor

  arguments :fact_id, :recipient_usernames, :sender_id, :content

  def execute
    c = command :create_conversation, @fact_id, @recipient_usernames
    command :create_message, @sender_id, @content, c

    sender = User.find(@sender_id)
    command :create_activity, sender.graph_user, :created_conversation, c, nil
  end
  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
