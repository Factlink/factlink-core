module Interactors
  module Feed
    class Count
      include Pavlov::Interactor

      arguments :timestamp

      def execute
        count = query :"feed/count", timestamp: get_timestamp
        {
          count: count,
          timestamp: get_timestamp
        }
      end

      def get_timestamp
        (timestamp || 0).to_i
      end

      def authorized?
        true
      end
    end
  end
end
