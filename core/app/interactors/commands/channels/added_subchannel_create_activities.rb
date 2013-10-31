module Commands
  module Channels
    class AddedSubchannelCreateActivities
      include Pavlov::Command

      arguments :channel

      def execute
        Channel::Activities.new(channel).add_created
      end
    end
  end
end
