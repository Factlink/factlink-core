module Interactors
  module Feed
    class Global
      include Pavlov::Interactor

      arguments :timestamp

      def authorized?
        true
      end

      def execute
        Backend::Activities.activities_older_than(activities_set: activities, timestamp: timestamp)
      end

      def activities
        GlobalFeed.instance.all_activities
      end
    end
  end
end
