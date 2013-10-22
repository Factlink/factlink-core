module Queries
  module Topics
    class PostedToByGraphUser
      include Pavlov::Query

      arguments :graph_user

      def execute
        topics
      end

      def topics
        topic_slugs.map do |slug|
          query :'topics/by_slug_title', slug_title: slug
        end.compact
      end

      def topic_slugs
        channels.map(&:slug_title)
      end

      def channels
        ChannelList.new(graph_user).channels.to_a
      end
    end
  end
end
