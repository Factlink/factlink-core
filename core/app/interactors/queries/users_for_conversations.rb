require_relative '../pavlov'
require 'hashie'

module Queries
  class UsersForConversations
    include Pavlov::Query

    arguments :conversations

    def validate
      @conversations.each do |conversation|
        raise 'id should be an hexadecimal string.' unless /\A[\da-fA-F]+\Z/.match conversation.id.to_s
      end
    end

    def execute
      users = all_recipients_by_id

      @conversations.each_with_object({}) do |c, hash|
        hash[c.id] = c.recipient_ids.map {|id| user_dead(users[id])}
      end
    end

    def all_recipients_by_id
      recipient_ids = @conversations.flat_map {|c| c.recipient_ids}.uniq
      recipients = User.any_in(_id: recipient_ids)
      recipients.each_with_object({}) {|u, hash| hash[u.id] = u}
    end

    def authorized?
      @options[:current_user] and
        @conversations.all? do |conversation|
          conversation.recipient_ids.include? @options[:current_user].id
        end
    end

    private
    def user_dead(user)
      Hashie::Mash.new(
        id: user.id,
        name: user.name,
        username: user.username,
        location: user.location,
        biography: user.biography,
        gravatar_hash: user.gravatar_hash
      )
    end
  end
end
