module Interactors
  module Channels
    class AddFact
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        command :"channels/add_fact", @fact, @channel

        if @fact.site
          command :'site/add_top_topic', @fact.site.id.to_i, @channel.topic.slug_title
        end

        command :create_activity, @channel.created_by, :added_fact_to_channel, @fact, @channel
      end

      def topic
        @channel.topic
      end

      def authorized?
        return true if @options[:no_current_user]
        return false unless @options[:current_user]

        @options[:current_user].graph_user_id == @channel.created_by_id
      end
    end
  end
end
