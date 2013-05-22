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

        graph_user_ids = query :'users/follower_graph_user_ids', user.graph_user_id.to_s
        users = query :users_by_graph_user_ids, graph_user_ids

        followed_by_me = graph_user_ids.include? @options[:current_user].graph_user_id

        count = users.length
        users = users.drop(skip).take(take)

        return users, count, followed_by_me
      end
    end
  end
end