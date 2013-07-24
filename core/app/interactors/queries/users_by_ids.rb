require 'pavlov'

module Queries
  class UsersByIds
    include Pavlov::Query

    arguments :user_ids, :pavlov_options

    def validate
      @user_ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      users = User.any_in(_id: @user_ids)
      users.map{|u| KillObject.user u}
    end
  end
end
