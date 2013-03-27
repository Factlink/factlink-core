module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.add_channel(subchannel)

        if success
          AddChannelToChannel.perform(subchannel, channel)
          command :'channels/added_subchannel_create_activities', channel, subchannel
        end
      end
    end
  end
end
