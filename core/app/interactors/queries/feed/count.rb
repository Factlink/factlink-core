module Queries
  module Feed
    class Count
      include Pavlov::Query

      arguments :timestamp

      def execute
        return 0 unless current_user

        activities.count_above(timestamp)
      end

      def activities
        current_user.graph_user.stream_activities
      end

      def current_user
        pavlov_options[:current_user]
      end
    end
  end
end
