require_relative '../../../classes/hash_utils'

module Queries
  module UserTopics
    class TopWithAuthorityForUser
      include Pavlov::Query
      include HashUtils

      arguments :user_id, :limit_topics

      private

      def validate
        validate_hexadecimal_string :user_id, user_id
        validate_integer :limit_topics, limit_topics
      end

      def execute
        topics_with_authorities
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
        @sorted_topics_hashes ||= [] # [{id: TOPIC_ID, authority: AUTH}]
      end

      def topics_for_hashes hashes
        ids = hashes.map {|h| h[:id]}

        topics = Topic.any_in(id: ids).to_a

        hash_with_index(:id, topics)
      end
    end
  end
end
