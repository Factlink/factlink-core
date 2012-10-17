module Commands
  class CreateMessage
    include Pavlov::Command

    # TODO: switch to using sender_id
    arguments :sender_username, :content, :conversation

    def execute
      m = Message.create
      m.sender = User.where(username: @sender_username).first
      m.content = @content
      m.conversation_id = @conversation.id
      m.save
      m
    end

    def authorized?                    # TODO convert this check to check on ids
      sender_id = User.where(username: @sender_username).first.id

      @conversation.recipient_ids.include? sender_id and
      sender_id == @options[:current_user].id

    end
  end
end