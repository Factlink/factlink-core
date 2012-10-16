class CreateConversationWithMessageInteractor
  include Activity::Subject
  include Pavlov::Interactor
  include Pavlov::SmartInit

  arguments :recipient_usernames, :sender_username, :content

  def execute
    c = command :create_conversation, @recipient_usernames
    command :create_message, @sender_username, @content, c.id

    activity User.where(username: @sender_username).first.graph_user, :created_conversation, c
  end
end
