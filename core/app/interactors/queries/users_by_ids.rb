require_relative '../pavlov'
require 'hashie'

module Queries
  class UsersByIds
    include Pavlov::Query

    arguments :ids

    def validate
      @ids.each do |id|
        validate_hexadecimal_string :id, id.to_s
      end
    end

    def execute
      recipients = User.any_in(_id: @ids)
      recipients.each_with_object({}) {|u, hash| hash[u.id] = user_dead(u)}
    end

    def authorized?
      @options[:current_user]
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
