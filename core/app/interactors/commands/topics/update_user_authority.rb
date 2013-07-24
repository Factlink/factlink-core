require 'pavlov'

module Commands
  module Topics
    class UpdateUserAuthority
      include Pavlov::Command

      arguments :graph_user_id, :topic_slug, :authority, :pavlov_options

      private

      def execute
        update_authority
        update_top_users
        update_users_top_topics
      end

      def update_authority
        Authority.from(topic, for: graph_user) << authority
      end

      def update_top_users
        topic.top_users_add(graph_user.user, authority)
      end

      def update_users_top_topics
        users_top_topics.set(topic.id, authority)
      end

      def users_top_topics
        TopicsSortedByAuthority.new(graph_user.user.id)
      end

      def topic
        @topic ||= old_query :'topics/by_slug_title', topic_slug
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
