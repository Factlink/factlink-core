module Commands
  module Channels
    class AddFact
      include Pavlov::Command

      arguments :fact, :channel

      def execute
        Channel::Activities.new(channel).add_created
        ChannelFacts.new(channel).add_fact fact
        AddFactToChannelJob.perform(fact.id, channel.id)
      end
    end
  end
end
