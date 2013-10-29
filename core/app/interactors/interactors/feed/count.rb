module Interactors
  module Feed
    class Count
      include Pavlov::Interactor

      arguments :timestamp

      def execute
        query :"feed/count", timestamp: timestamp
      end

      def authorized?
        true
      end
    end
  end
end
