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
        @options[:no_current_user] == true or @options[:current_user]
      end
    end
  end
end
