module Interactors
  module Channels
    class AddFact
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        command :"channels/add_fact", fact: fact, channel: channel

        add_to_topic
      end

      def add_to_topic
        command :"topics/add_fact",
          fact_id: fact.id,
          topic_slug_title: channel.slug_title,
          score: ''
      end

      def site
        fact.site
      end

      def topic
        channel.topic
      end

      def authorized?
        # TODO use cancan
        return false unless pavlov_options[:current_user]

        pavlov_options[:current_user].graph_user_id == channel.created_by_id
      end
    end
  end
end
