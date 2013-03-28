module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.add_channel(subchannel)

        if success
          AddChannelToChannel.perform(subchannel, channel)
        end

        success
      end
    end
  end
end
