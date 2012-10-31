require_relative '../pavlov'

module Commands
  class CreateMessage
    include Pavlov::Command

    arguments :sender_id, :content, :conversation

    def validate
      raise 'Message cannot be empty.' unless @content.length > 0
      raise 'Message cannot be longer than 5000 characters.' unless @content.length <= 5000
      validate_hexadecimal_string :conversation_id, @conversation.id.to_s
    end

    def execute
      @conversation.save # update the updated_at attribute
      message = Message.new
      message.sender_id = @sender_id
      message.content = @content
      message.conversation_id = @conversation.id
      message.save
      message
    end

    def authorized?
      @conversation.recipient_ids.map(&:to_s).include? @sender_id and
      @sender_id == @options[:current_user].id.to_s
    end
  end
end
