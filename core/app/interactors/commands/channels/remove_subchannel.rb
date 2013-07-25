module Commands
  module Channels
    class RemoveSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel
      attribute :pavlov_options, Hash, default: {}

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
