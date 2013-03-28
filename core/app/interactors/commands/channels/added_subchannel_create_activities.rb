module Commands
  module Channels
    class AddedSubchannelCreateActivities
      include Pavlov::Command

      arguments :channel, :subchannel

      def execute
        Channel::Activities.new(channel).add_created
        channel.activity(channel.created_by,:added_subchannel,subchannel,:to,channel)
      end
    end
  end
end
