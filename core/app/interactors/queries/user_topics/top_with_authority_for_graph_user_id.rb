require_relative '../../../classes/hash_utils'

module Queries
  module UserTopics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query
      include HashUtils

      arguments :graph_user_id, :limit_topics
      attribute :pavlov_options, Hash, default: {}

      private

      def validate
        validate_integer_string :graph_user_id, graph_user_id
        validate_integer :limit_topics, limit_topics
      end

      def execute
        user_topics
      end

      def user_topics
        topics_with_authorities.compact
      end

      def topics_with_authorities
        sorted_authorities.zip(sorted_topics).map do |args|
          dead_topic_for *args
        end.compact
      end

      def sorted_authorities
        sorted_topics_hashes.map {|h| h[:authority]}
      end

      def sorted_topics
        topics_for_ids = topics_for_hashes(sorted_topics_hashes)

        sorted_topics_hashes.map do |hash|
          topics_for_ids[hash[:id].to_s]
        end
      end

      def dead_topic_for authority, topic
        return nil unless topic

        DeadUserTopic.new topic.slug_title,
                          topic.title,
                          authority
      end

      def sorted_topics_hashes
        @sorted_topics_hashes ||=
          topics_sorted_by_authority.ids_and_authorities_desc_limit limit_topics
      end

      def topics_sorted_by_authority
        TopicsSortedByAuthority.new(graph_user.user_id.to_s)
      end

      def topics_for_hashes hashes
        ids = hashes.map {|h| h[:id]}

        topics = Topic.any_in(id: ids).to_a

        hash_with_index(:id, topics)
      end

      def graph_user
        @graph_user ||= GraphUser[graph_user_id]
      end
    end
  end
end
