module Interactors
  module Feed
    class GlobalDiscussions
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
        GlobalFeed.instance.all_discussions
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
        validate_string :count, count unless count.nil?
      end
    end
  end
end
