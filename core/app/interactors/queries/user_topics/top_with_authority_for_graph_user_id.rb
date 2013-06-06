module Queries
  module UserTopics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query

      arguments :graph_user_id, :limit_topics

      def execute
        user_topics
      end

      def user_topics
        sorted_topics_hashes.map do |hash|
          user_topic_for_hash hash
        end.compact
      end

      def sorted_topics_hashes
        user_topics_by_authority = UserTopicsByAuthority.new(graph_user.user_id.to_s)
        user_topics_by_authority.ids_and_authorities_desc_limit limit_topics
      end

      def user_topic_for_hash hash
        topic = Topic.find(hash[:id])
        return nil unless topic

        DeadUserTopic.new topic.slug_title,
                          topic.title,
                          hash[:authority]
      end

      def graph_user
        @graph_user ||= GraphUser[graph_user_id]
      end
    end
  end
end
