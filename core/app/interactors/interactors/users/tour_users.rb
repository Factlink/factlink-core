module Interactors
  module Users
    class TourUsers
      include Pavlov::Interactor
      include Util::CanCan

      def execute
        users.map(&method(:with_user_topics))
      end

      def with_user_topics user
        KillObject.user user,
          top_user_topics: user_topics(user)
      end

      def user_topics user
        old_query :'user_topics/top_with_authority_for_graph_user_id',
              user.graph_user_id, 2
      end

      def users
        old_query :"users/handpicked"
      end

      def authorized?
        can? :index, User
      end
    end
  end
end
