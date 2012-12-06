require 'redis/aid'

module Queries
  module Site
    class TopTopics
      include Redis::Aid::Ns(:site)
      include Pavlov::Query

      arguments :site_id

      def validate
        validate_integer :site_id, @site_id
      end

      def key
        redis[@site_id][:top_topics]
      end

      def execute
        topic_ids = key.zrevrange(0, 2)
        topic_ids.map { |id| Topic.find(id) }
      end
    end
  end
end
