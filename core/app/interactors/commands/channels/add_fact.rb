module Commands
  module Channels
    class AddFact
      include Pavlov::Command

      arguments :fact, :channel, :pavlov_options

      def execute
        ChannelFacts.new(@channel).add_fact @fact
      end
    end
  end
end
