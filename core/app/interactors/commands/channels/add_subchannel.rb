module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.add_channel(subchannel)

        if success
          command(:'channels/add_facts_from_channel_to_channel',
                      subchannel: subchannel, channel: channel)
        end

        success
      end
    end
  end
end
