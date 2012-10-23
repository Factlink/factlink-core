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
      recipient_ids = @conversations.map {|conversation| conversation.recipient_ids}.flatten.uniq

      # Find all corresponding users and index them by id
      users = Hash[User.any_in(_id: recipient_ids).map {|user| [user.id.to_s, user_hash(user)]}]

      @conversations.each do |conversation|
        conversation.recipients = conversation.recipient_ids.map {|id| users[id.to_s]}
      end
    end

    def authorized?
      @options[:current_user] and
      @conversations.each do |conversation|
        conversation.recipient_ids.include? @options[:current_user].id
      end
    end

    private
    def user_hash(user)
      Hashie::Mash.new(
        id: user.id,
        name: user.name.blank? ? user.username : user.name,
        username: user.username,
        location: user.location,
        biography: user.biography,
        gravatar_hash: user.gravatar_hash
      )
    end
  end
end
