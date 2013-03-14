module Commands
  module Channels
    class RemoveSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        channel.remove_channel(subchannel)
      end
    end
  end
end
