require 'pavlov'

module Interactors
  module Users
    class Followers
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

        users = query :'users/follower_ids', user.id.to_s
        followed_by_me = users.include? @options[:current_user].id
        count = users.length
        users = users.drop(skip).take(take)

        return users, count, followed_by_me
      end
    end
  end
end
