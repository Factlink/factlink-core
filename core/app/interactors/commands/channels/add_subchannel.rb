module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.add_channel(subchannel)

        if success
          Commands::Channels::AddFactsFromChannelToChannel.perform(subchannel, channel)
        end

        success
      end
    end
  end
end
