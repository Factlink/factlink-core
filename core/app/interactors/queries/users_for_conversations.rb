require_relative '../pavlov'
require 'hashie'

module Queries
  class UsersForConversations
    include Pavlov::Query

    arguments :conversations

    def execute
      recipient_ids = @conversations.map {|conversation| conversation.recipient_ids}.flatten.uniq

      # Find all corresponding users and index them by id
      users = Hash[User.any_in(_id: recipient_ids).map {|user| [user.id, user_hash(user)]}]

      puts users.to_s

      @conversations.each do |conversation|
        conversation.recipients = conversation.recipient_ids.map {|id| users[id]}
      end
    end

    def authorized?
      true
    end

    private
    def user_hash(user)
      Hashie::Mash.new(
        id: user.id,
        name: user.name,
        location: user.location,
        biography: user.biography,
        gravatar_hash: user.gravatar_hash
      )
    end
  end
end
