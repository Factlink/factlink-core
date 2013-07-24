module Commands
  module Channels
    class RemoveSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel, :pavlov_options

      def execute
        success = channel.remove_channel(subchannel)

        if success
          Resque.enqueue(RemoveChannelFromChannel, subchannel.id, channel.id)
        end

        success
      end
    end
  end
end
