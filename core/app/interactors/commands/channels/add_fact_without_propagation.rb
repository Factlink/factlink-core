module Commands
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Command

      arguments :fact, :channel, :score

      def execute
        fact.channels.add channel

        true
      end
    end
  end
end
