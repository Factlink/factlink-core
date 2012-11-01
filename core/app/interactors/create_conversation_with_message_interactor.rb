require_relative 'pavlov'

class CreateConversationWithMessageInteractor
  include Pavlov::Interactor
  include Pavlov::Mixpanel

  arguments :fact_id, :recipient_usernames, :sender_id, :content

  def execute
    conversation = command :create_conversation, @fact_id, @recipient_usernames

    begin
      command :create_message, @sender_id, @content, conversation
    rescue
      conversation.delete
      raise
    end

    sender = User.find(@sender_id)
    command :create_activity, sender.graph_user, :created_conversation, conversation, nil

    track_mixpanel
  end

  def track_mixpanel
    track_event :conversation_created
    increment_person_event :conversations_created
  end

  def authorized?
    #relay authorization to commands, only require a user to check
    @options[:current_user]
  end
end
