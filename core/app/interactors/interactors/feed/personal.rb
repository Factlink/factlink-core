module Interactors
  module Feed
    class Personal
      include Pavlov::Interactor

      arguments :timestamp

      def authorized?
        pavlov_options[:current_user]
      end

      def execute
        Backend::Activities.personal(newest_timestamp: timestamp,
          user_id: pavlov_options[:current_user].id)
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
      end
    end
  end
end
