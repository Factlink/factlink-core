module Commands
  module Stream
    class AddActivitiesOfUserToStream
      include Pavlov::Command
      arguments :graph_user_id

      def execute
        old_command :'stream/add_activities', activities
      end

      def activities
        old_query :'activities/for_followers_stream', graph_user_id
      end

    end
  end
end
