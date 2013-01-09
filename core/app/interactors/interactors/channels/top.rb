require_relative './index.rb'

module Interactors
  module Channels
    class Top < Index
      arguments

      def get_alive_channels
        handpicked_channels.sample(12)
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
