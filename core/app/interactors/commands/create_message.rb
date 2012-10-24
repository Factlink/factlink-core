require_relative '../pavlov'

module Commands
  class CreateMessage
    include Pavlov::Command

    # TODO: switch to using sender_id
    arguments :sender_username, :content, :conversation

    def validate
      raise 'Message cannot be empty.' unless @content.length > 0
      raise 'Message cannot be longer than 5000 characters.' unless @content.length <= 5000
      validate_hexadecimal_string :conversation_id, @conversation.id.to_s
    end

    def execute
      message = Message.create
      message.sender = User.where(username: @sender_username).first
      message.content = @content
      message.conversation_id = @conversation.id
      message.save
      message
    end

    def authorized?                    # TODO convert this check to check on ids
      sender_id = User.where(username: @sender_username).first.id

      @conversation.recipient_ids.include? sender_id and
      sender_id == @options[:current_user].id

    end
  end
end
