module Interactors
  module Channels
    class AddFact
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        command :"channels/add_fact", fact: fact, channel: channel

        add_top_topic
        create_activity
      end

      def add_top_topic
        return unless site

        command :'site/add_top_topic',
                    site_id: site.id.to_i,
                    topic_slug: topic.slug_title
      end

      def create_activity
        # if there is no topic, this isn't a real channel,
        # but a created_facts, or a stream
        return unless topic

        command :create_activity, graph_user: channel.created_by,
                   action: :added_fact_to_channel,
                   subject: fact,
                   object: channel
      end

      def site
        fact.site
      end

      def topic
        channel.topic
      end

      def authorized?
        # TODO use cancan
        return true if pavlov_options[:no_current_user]
        return false unless pavlov_options[:current_user]

        pavlov_options[:current_user].graph_user_id == channel.created_by_id
      end
    end
  end
end
