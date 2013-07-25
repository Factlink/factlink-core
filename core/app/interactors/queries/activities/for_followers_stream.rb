module Queries
  module Activities
    class ForFollowersStream
      include Pavlov::Query
      arguments :graph_user_id
      attribute :pavlov_options, Hash, default: {}

      # We currently only use this for selecting some activities
      # when following another user.

      def execute
        # 7 activities seems about right...
        relevant_activities.take(7)
      end

      def relevant_activities
        recent_activities.select do |activity|
          listener.matches_any?(activity)
        end
      end

      def recent_activities
        # To get 7 relevant activities activities retrieving
        # 40 usually works
        Activity.find(user_id: graph_user_id)
                .sort(order: 'DESC', limit: 40)
      end

      def listener
        @listener ||= Activity::Listener::Stream.new
      end
    end
  end
end
