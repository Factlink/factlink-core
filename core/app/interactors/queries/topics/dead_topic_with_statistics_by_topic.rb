module Queries
  module Topics
    class DeadTopicWithStatisticsByTopic
      include Pavlov::Query

      arguments :alive_topic

      private

      def execute
        DeadTopic.new alive_topic.slug_title,
                      alive_topic.title,
                      current_user_authority,
                      facts_count,
                      favouritours_count
      end

      def facts_count
        query(:'topics/facts_count', slug_title: alive_topic.slug_title)
      end

      def current_user_authority
        query(:'authority_on_topic_for',
                  topic: alive_topic,
                  graph_user: pavlov_options[:current_user].graph_user)
      end

      def favouritours_count
        query(:'topics/favouritours_count', topic_id: alive_topic.id)
      end

      def validate
        validate_not_nil :alive_topic, alive_topic
      end
    end
  end
end
