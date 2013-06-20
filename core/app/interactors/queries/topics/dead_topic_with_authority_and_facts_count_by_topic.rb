module Queries
  module Topics
    class DeadTopicWithAuthorityAndFactsCountByTopic
      include Pavlov::Query

      arguments :alive_topic

      def execute
        DeadTopic.new alive_topic.slug_title,
                      alive_topic.title,
                      current_user_authority,
                      facts_count
      end

      def facts_count
        query :'topics/facts_count', alive_topic.slug_title
      end

      def current_user_authority
        query :authority_on_topic_for, alive_topic, @options[:current_user].graph_user
      end

      def validate
        validate_not_nil :alive_topic, alive_topic
      end
    end
  end
end
