require_relative '../pavlov'
require 'hashie'

module Queries
  class UsersByIds
    include Pavlov::Query

    arguments :ids

    def validate
      @ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      recipients = User.any_in(_id: @ids)
      recipients.each_with_object({}) {|u, hash| hash[u.id] = KillObject.user u}
    end

    def authorized?
      @options[:current_user]
    end
  end
end
