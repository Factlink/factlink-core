require 'pavlov'

module Commands
  module Topics
    class Unfavourite
      include Pavlov::Command

      arguments :graph_user_id, :topic_id, :pavlov_options

      def execute
        users_favourited_topics.unfavourite topic_id
      end

      def users_favourited_topics
        UserFavouritedTopics.new(graph_user_id)
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
        validate_hexadecimal_string :topic_id, topic_id
      end
    end
  end
end
