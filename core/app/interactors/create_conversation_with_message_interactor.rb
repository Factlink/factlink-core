class CreateConversationWithMessageInteractor
  include Interactor
  include Activity::Subject

  def initialize(recipients, sender, content) # add subject_type and subject_id
    @recipient_usernames = recipients
    @sender_username = sender
    @content = content
  end
  def execute
    c = Conversation.new
    @recipient_usernames.each do |name|
      c.recipients << user_for(name)
    end
    c.save
    m = created_message
    m.conversation = c
    m.save

    activity user_for(@sender_username).graph_user, :created_conversation, c
  end

  def created_message
    m = Message.create
    m.sender = user_for(@sender_username)
    m.content = @content
    m.save or raise 'hell'
    m
  end

  def user_for(username)
    User.where(username: username).first
  end
end
