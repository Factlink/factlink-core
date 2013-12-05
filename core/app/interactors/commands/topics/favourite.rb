module Commands
  module Topics
    class Favourite
      include Pavlov::Command

      arguments :graph_user_id, :topic_id

      def execute
        users_favourited_topics.favourite topic_id
      end

      def users_favourited_topics
        UserFavouritedTopics.new(graph_user_id)
      end
    end
  end
end
