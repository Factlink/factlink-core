module Queries
  module Users
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        users
      end

      def users
        query(:'users_by_ids', user_ids: user_ids, top_topics_limit: 2)
      end

      def user_ids
        HandpickedTourUsers.new.ids
      end
    end
  end
end
