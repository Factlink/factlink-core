module Queries
  module Activities
    class ForFollowersStream
      include Pavlov::Query
      arguments :graph_user_id

      def execute
        activities.below('inf',
                         count: 7,
                         reversed: true,
                         withscores: false).compact
      end

      def activities
        graph_user = GraphUser[graph_user_id]
        graph_user.own_activities
      end
    end
  end
end
