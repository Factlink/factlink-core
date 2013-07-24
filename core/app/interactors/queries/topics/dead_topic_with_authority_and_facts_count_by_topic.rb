module Queries
  module Topics
    class DeadTopicWithAuthorityAndFactsCountByTopic
      include Pavlov::Query

      arguments :alive_topic, :pavlov_options

      private

      def execute
        DeadTopic.new alive_topic.slug_title,
                      alive_topic.title,
                      current_user_authority,
                      facts_count
      end

      def facts_count
        old_query :'topics/facts_count', alive_topic.slug_title
      end

      def current_user_authority
        old_query :authority_on_topic_for, alive_topic, pavlov_options[:current_user].graph_user
      end

      def validate
        validate_not_nil :alive_topic, alive_topic
      end
    end
  end
end
