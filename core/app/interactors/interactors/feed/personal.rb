module Interactors
  module Feed
    class Personal
      include Pavlov::Interactor

      arguments :timestamp

      def authorized?
        true
      end

      def execute
        return [] unless current_user

        Backend::Activities.activities_older_than(activities_set: activities, timestamp: timestamp)
      end

      def activities
        current_user.stream_activities
      end

      def current_user
        pavlov_options[:current_user]
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
      end
    end
  end
end
