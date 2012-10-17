require_relative '../pavlov'

module Commands
  class CreateConversation
    include Pavlov::Command

    arguments :recipient_usernames

    def validate
      raise 'recipient_usernames should be a list'    unless @recipient_usernames.respond_to? :each
      raise 'recipient_usernames should not be empty' unless @recipient_usernames.length > 0
    end

    def execute
      conversation = Conversation.new
      @recipient_usernames.each do |username|
        conversation.recipients << User.where(username: username).first
      end
      conversation.save
      conversation
    end
  end
end
