require 'pavlov'

module Commands
  module Topics
    class UpdateUserAuthority
      include Pavlov::Command

      arguments :graph_user_id, :topic_slug, :authority

      def execute
        Authority.from(topic, for: graph_user) << authority
      end

      def topic
        query :'topics/by_slug_title', topic_slug
      end

      def graph_user
        GraphUser[graph_user_id]
      end

      def validate
        validate_integer :authority, authority
        validate_integer_string :graph_user_id, graph_user_id
        validate_string :topic_slug, topic_slug
      end
    end
  end
end
