require_relative 'pavlov'

class CreateConversationWithMessageInteractor
  include Pavlov::Interactor

  # TODO: use sender_id instead of username
  arguments :fact_id, :recipient_usernames, :sender_username, :content

  def execute
    sender = User.where(username: @sender_username).first
    raise 'Username does not exist' if !sender

    c = command :create_conversation, @fact_id, @recipient_usernames
    command :create_message, sender.id, @content, c

    command :create_activity, sender.graph_user, :created_conversation, c
  end
  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
