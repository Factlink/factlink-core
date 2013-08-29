module Queries
  module Users
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        users
      end

      def users
        query(:'users_by_ids', user_ids: user_ids)
      end

      def user_ids
        HandpickedTourUsers.new.ids
      end
    end
  end
end
