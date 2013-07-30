module Queries
  module Topics
    class ByIdWithAuthorityAndFactsCount
      include Pavlov::Query

      arguments :id

      private

      def execute
        topic = Topic.find id
        old_query :'topics/dead_topic_with_authority_and_facts_count_by_topic', topic
      end

      def validate
        validate_hexadecimal_string :id, id
      end
    end
  end
end
