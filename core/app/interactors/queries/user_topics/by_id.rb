module Queries
  module UserTopics
    class ById
      include Pavlov::Query

      arguments :id

      def execute
        DeadUserTopic.new topic.slug_title,
                          topic.title,
                          current_user_authority,
                          facts_count
      end

      def topic
        @topic ||= Topic.find id
      end

      def facts_count
        query :'topics/facts_count', topic.slug_title
      end

      def current_user_authority
        query :authority_on_topic_for, topic, @options[:current_user].graph_user
      end

      def validate
        validate_hexadecimal_string :id, id
      end
    end
  end
end
