module Interactors
  module Users
    class Feed
      include Pavlov::Interactor

      arguments :timestamp, :username

      def authorized?
        true
      end

      def execute
        Backend::Activities.users(newest_timestamp: timestamp, username: username)
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
      end
    end
  end
end
