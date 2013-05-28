module Queries
  module Activities
    class ForFollowersStream
      include Pavlov::Query
      arguments :graph_user_id

      def execute
        relevant_activities
      end

      def relevant_activities
        recent_activities.select do |activity|
          listener.matches_any?(activity)
        end
      end

      def recent_activities
        Activity.find(user_id: graph_user_id)
                .sort(order: 'DESC', limit: 23)
      end

      def listener
        @listener ||= Activity::Listener::Stream.new
      end

    end
  end
end
