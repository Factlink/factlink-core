module Interactors
  module Channels
    class AddFact
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        old_command :"channels/add_fact", fact, channel

        add_top_topic
        create_activity
      end

      def add_top_topic
        return unless site

        old_command :'site/add_top_topic',
          site.id.to_i, topic.slug_title
      end

      def create_activity
        # if there is no topic, this isn't a real channel,
        # but a created_facts, or a stream
        return unless topic

        old_command :create_activity, channel.created_by,
          :added_fact_to_channel, fact, channel
      end

      def site
        fact.site
      end

      def topic
        channel.topic
      end

      def authorized?
        # TODO use cancan
        return true if @options[:no_current_user]
        return false unless @options[:current_user]

        @options[:current_user].graph_user_id == @channel.created_by_id
      end
    end
  end
end
