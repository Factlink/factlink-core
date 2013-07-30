require 'pavlov'

module Queries
  module Channels
    class ActivityCount
      include Pavlov::Query

      arguments :channel_id, :timestamp

      def execute
        Channel[@channel_id].activities.count_above(@timestamp)
      end
    end
  end
end
