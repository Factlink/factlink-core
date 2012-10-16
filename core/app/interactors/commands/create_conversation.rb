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
  end
end