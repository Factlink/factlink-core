module SmartInit
  extend ActiveSupport::Concern
  module ClassMethods
    # arguments :foo, :bar
    #
    # results in
    #
    # def initialize(foo, bar)
    #   @foo = foo
    #   @bar = bar
    # end
    def arguments *keys
      define_method :initialize do |*names|
        (keys.zip names).each do |pair|
          name = "@" + pair[0].to_s
          value = pair[1]
          instance_variable_set(name, value)
        end
      end
    end
  end
end

module Command
  extend ActiveSupport::Concern
  include SmartInit
end

class CreateMessageCommand
  include Command
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

class CreateConversationCommand
  include Command
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

class CreateConversationWithMessageInteractor
  include Interactor
  include SmartInit

  arguments :recipient_usernames, :sender_username, :content

  def execute
    c = command :create_conversation, @recipient_usernames
    command :create_message, @sender_username, @content, c.id
    # TODO: create activity :created_conversation,
    #       and add it to notifications of (receivers-[sender]) via
    #       create_listeners.rb
  end
end