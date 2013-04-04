require 'pavlov'

module Interactors
  module Users
    class FollowingUsers
      include Pavlov::Interactor

      arguments :user_name, :skip, :take

      def authorized?
        !! @options[:current_user]
      end

      def validate
        validate_nonempty_string :user_name, @user_name
        validate_integer :skip, @skip
        validate_integer :take, @take
      end

      def execute
        user = query :user_by_username, @user_name
        users = query :'users/following_user_ids', user.id, @skip, @take
        count = query :'users/following_count', user.id

        return users, count
      end
    end
  end
end
