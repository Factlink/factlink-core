require 'pavlov'

module Queries
  module Channels
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        handpicked_channel_ids.map do |channel_id|
          Channel[channel_id]
        end
      end

      def handpicked_channel_ids
        TopChannels.new.ids
      end
    end
  end
end
