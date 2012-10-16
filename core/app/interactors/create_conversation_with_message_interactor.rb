class CreateConversationWithMessageInteractor
  include Pavlov::Interactor
  include Pavlov::SmartInit

  arguments :recipient_usernames, :sender_username, :content

  def execute
    c = command :create_conversation, @recipient_usernames
    command :create_message, @sender_username, @content, c.id
    # TODO: create activity :created_conversation,
    #       and add it to notifications of (receivers-[sender]) via
    #       create_listeners.rb
  end
end