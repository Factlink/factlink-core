module Interactors
  module Users
    class Feed
      include Pavlov::Interactor

      arguments :timestamp, :username

      def authorized?
        true
      end

      def execute
        Backend::Activities.activities_older_than(activities_set: activities, timestamp: timestamp)
      end

      def activities
        user = User.where(username: username).first
        user.graph_user.own_activities
      end
    end
  end
end
