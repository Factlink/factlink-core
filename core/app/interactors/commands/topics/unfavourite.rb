module Commands
  module Topics
    class Unfavourite
      include Pavlov::Command

      arguments :graph_user_id, :topic_id

      def execute
        users_favourited_topics.unfavourite topic_id
      end

      def users_favourited_topics
        UserFavouritedTopics.new(graph_user_id)
      end
    end
  end
end
