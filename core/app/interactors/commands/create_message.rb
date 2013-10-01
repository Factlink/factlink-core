module Commands
  class CreateMessage
    include Pavlov::Command

    arguments :sender_id, :content, :conversation

    def validate
      unless content.strip.length > 0
        errors.add :content, 'cannot be empty'
      end
      unless content.length <= 5000
        errors.add :content, 'cannot be longer than 5000 characters.'
      end
      validate_hexadecimal_string :conversation_id, conversation.id.to_s
    end

    def execute
      conversation.save # update the updated_at attribute
      message = Message.new
      message.sender_id = sender_id
      message.content = content
      message.conversation_id = conversation.id
      message.save
      message
    end

    def authorized?
      conversation.recipient_ids.map(&:to_s).include? sender_id and
        sender_id == pavlov_options[:current_user].id.to_s
    end
  end
end
