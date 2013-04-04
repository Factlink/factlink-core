require 'pavlov'

module Interactors
  module Users
    class FollowingUsers
      include Pavlov::Interactor

      arguments :user_id, :skip, :take

      def authorized?
        !! @options[:current_user]
      end

      def validate
        validate_hexadecimal_string :user_id, @user_id
        validate_integer :skip, @skip
        validate_integer :take, @take
      end

      def execute
        users = query :'users/following_user_ids', @user_id, @skip, @take
        count = query :'users/following_count', @user_id

        return users, count
      end
    end
  end
end
