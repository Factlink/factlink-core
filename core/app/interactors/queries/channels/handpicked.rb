require 'pavlov'

module Queries
  module Channels
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        non_dead_handpicked_channels
      end

      def non_dead_handpicked_channels
        handpicked_channels.delete_if do |channel|
          channel.nil?
        end
      end

      def handpicked_channels
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
