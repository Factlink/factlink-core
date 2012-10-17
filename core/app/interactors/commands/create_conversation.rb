module Commands
  class CreateConversation
    include Pavlov::Command
    arguments :recipient_usernames
    def execute
      c = Conversation.new
      @recipient_usernames.each do |username|
        c.recipients << User.where(username: username).first
      end
      c.save
      c
    end
    def authorized?
      true # TODO this should be improved, but currently we have no rules for this
    end
  end
end