module Interactors
  module Feed
    class Global
      include Pavlov::Interactor

      arguments :timestamp, :count

      def authorized?
        true
      end

      def execute
        Backend::Activities.activities_older_than(activities_set: activities,
          timestamp: timestamp, count: count)
      end

      def activities
        GlobalFeed.instance.all_activities
      end

      def validate
        validate_string :timestamp, timestamp
        validate_string :count, count
      end
    end
  end
end
