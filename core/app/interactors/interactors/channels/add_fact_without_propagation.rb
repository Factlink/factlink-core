module Interactors
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Interactor

      arguments :fact, :channel, :score

      def execute
        fact.channels.add channel

        command :"topics/add_fact",
          fact_id: fact.id,
          topic_slug_title: channel.slug_title,
          score: score.to_s
        true
      end

      def authorized?
        true
      end
    end
  end
end
