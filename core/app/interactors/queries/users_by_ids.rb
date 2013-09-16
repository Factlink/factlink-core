module Queries
  class UsersByIds
    include Pavlov::Query

    arguments :user_ids

    private

    def validate
      @user_ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      users = User.any_in(_id: @user_ids)
      users.map(&method(:kill))
    end

    def kill user
      KillObject.user user,
        statistics: statistics(user)
    end

    def statistics user
      {}
    end
  end
end
