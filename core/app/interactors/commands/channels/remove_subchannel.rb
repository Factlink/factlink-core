module Commands
  module Channels
    class RemoveSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.remove_channel(subchannel)

        if success
          Resque.enqueue(RemoveChannelFromChannel, subchannel.id, channel.id)
          channel.activity(channel.created_by, :removed, subchannel, :to, channel)
        end
      end
    end
  end
end
