require_relative '../pavlov'

module Commands
  class CreateMessage
    include Pavlov::Command
    arguments :sender_username, :content, :conversation_id

    def validate
      raise 'Message cannot be empty.' unless @content.length > 0
      raise 'Message cannot be longer than 5000 characters.' unless @content.length <= 5000
      raise 'conversation_id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match @conversation_id.to_s
    end

    def execute
      message = Message.create
      message.sender = User.where(username: @sender_username).first
      message.content = @content
      message.conversation_id = @conversation_id
      message.save
      message
    end
  end
end
