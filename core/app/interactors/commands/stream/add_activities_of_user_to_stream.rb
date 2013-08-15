module Commands
  module Stream
    class AddActivitiesOfUserToStream
      include Pavlov::Command
      arguments :graph_user_id

      def execute
        command(:'stream/add_activities', activities: activities)
      end

      def activities
        query(:'activities/for_followers_stream', graph_user_id: graph_user_id)
      end

    end
  end
end
