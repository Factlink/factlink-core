module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        success = channel.add_channel(subchannel)

        if success
          Channel::Activities.new(channel).add_created
          AddChannelToChannel.perform(subchannel, channel)
          channel.activity(channel.created_by,:added_subchannel,subchannel,:to,channel)
        end
      end
    end
  end
end
