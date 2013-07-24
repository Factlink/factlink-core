require 'pavlov'

module Queries
  module Topics
    class FavouriteTopicIds
      include Pavlov::Query

      arguments :graph_user_id, :pavlov_options

      def execute
        users_favourited_topics.topic_ids
      end

      def users_favourited_topics
        UserFavouritedTopics.new(graph_user_id)
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
      end
    end
  end
end
