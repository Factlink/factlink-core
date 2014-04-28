module Interactors
  module Feed
    class Personal
      include Pavlov::Interactor

      arguments :timestamp

      def authorized?
        true
      end

      def execute
        [] # TODO
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
      end
    end
  end
end
