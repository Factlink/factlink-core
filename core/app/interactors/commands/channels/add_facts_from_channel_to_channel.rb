module Commands
  module Channels
    class AddFactsFromChannelToChannel
      include Pavlov::Command
      NUMBER_OF_INITIAL_FACTS = 10

      arguments :subchannel, :channel

      def execute
        latest_facts.each do |fact|
          command(:'channels/add_fact_without_propagation',
                      fact: fact, channel: channel, score: nil)
        end
      end

      def latest_facts
        subchannel.sorted_internal_facts.below('inf', count: NUMBER_OF_INITIAL_FACTS)
      end
    end
  end
end
