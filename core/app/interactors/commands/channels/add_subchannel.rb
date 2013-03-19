module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        channel.add_channel(subchannel)
      end
    end
  end
end
