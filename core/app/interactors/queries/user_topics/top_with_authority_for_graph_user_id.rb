module Queries
  module UserTopics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query

      arguments :graph_user_id, :limit_topics

      def execute
        sorted_user_topics.take(limit_topics)
      end

      def sorted_user_topics
        user_topics.sort do |a,b|
          - (a.authority <=> b.authority)
        end
      end

      def user_topics
        topics.map do |topic|
          DeadUserTopic.new topic.slug_title,
                            topic.title,
                            authority_for(topic)
        end
      end

      def authority_for topic
        query :authority_on_topic_for, topic, graph_user
      end

      def topics
        query :'topics/posted_to_by_graph_user', graph_user
      end

      def graph_user
        @graph_user ||= GraphUser[graph_user_id]
      end
    end
  end
end
