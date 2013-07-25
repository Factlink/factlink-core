module Commands
  module Channels
    class AddFact
      include Pavlov::Command

      arguments :fact, :channel
      attribute :pavlov_options, Hash, default: {}

      def execute
        ChannelFacts.new(@channel).add_fact @fact
      end
    end
  end
end
