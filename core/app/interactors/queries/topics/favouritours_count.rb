module Queries
  module Topics
    class FavouritoursCount
      include Pavlov::Query

      attribute :topic_id, String

      def execute
        TopicsFavouritedByUsers.new(topic_id).favouritours_count
      end
    end
  end
end
