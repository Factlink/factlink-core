require_relative 'pavlov'

class CreateConversationWithMessageInteractor
  include Pavlov::Interactor

  arguments :recipient_usernames, :sender_username, :content

  def execute
    c = command :create_conversation, @recipient_usernames
    command :create_message, @sender_username, @content, c

    command :create_activity, User.where(username: @sender_username).first.graph_user, :created_conversation, c
  end
  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
