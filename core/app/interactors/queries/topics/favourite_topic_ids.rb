module Queries
  module Topics
    class FavouriteTopicIds
      include Pavlov::Query

      arguments :graph_user_id

      def execute
        users_favourited_topics.topic_ids
      end

      def users_favourited_topics
        UserFavouritedTopics.new(graph_user_id)
      end
    end
  end
end
