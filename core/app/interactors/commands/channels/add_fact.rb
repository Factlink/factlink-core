module Commands
  module Channels
    class AddFact
      include Pavlov::Command

      arguments :fact, :channel

      def execute
        channel.sorted_internal_facts.add(fact)
        fact.channels.add(channel)
      end
    end
  end
end
