require 'pavlov'

module Commands
  module Topics
    class UpdateUserAuthority
      include Pavlov::Command

      arguments :graph_user_id, :topic_slug, :authority

      def execute
        update_authority
        update_top_users
      end

      def update_authority
        Authority.from(topic, for: graph_user) << authority
      end

      def update_top_users
        return unless graph_user.user
          # HACK: needed for tests which has gu's without user

        topic.top_users_add(graph_user.user, authority)
      end

      def topic
        @topic ||= query :'topics/by_slug_title', topic_slug
      end

      def graph_user
        @graph_user ||= GraphUser[graph_user_id]
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
        validate_string :topic_slug, topic_slug
      end
    end
  end
end
