module Commands
  class CreateMessage
    include Pavlov::Command
    arguments :sender_username, :content, :conversation_id

    def execute
      m = Message.create
      m.sender = User.where(username: @sender_username).first
      m.content = @content
      m.conversation_id = @conversation_id
      m.save
      m
    end
  end
end