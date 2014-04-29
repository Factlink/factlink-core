module Interactors
  module Feed
    class Global
      include Pavlov::Interactor

      arguments :timestamp, :count

      def authorized?
        true
      end

      def execute
        Backend::Activities.global(newest_timestamp: timestamp, count: count)
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
        validate_string :count, count unless count.nil?
      end
    end
  end
end
