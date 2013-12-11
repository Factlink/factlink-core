module Queries
  module Site
    class TopTopics
      include Redis::Aid::Ns(:site)
      include Pavlov::Query

      arguments :site_id, :nr

      def validate
        validate_integer :site_id, site_id
        validate_integer :nr, nr
      end

      def key
        redis[site_id][:top_topics]
      end

      def execute
        topics.map do |t|
          DeadTopic.new t.slug_title, t.title
        end
      end

      def topics
        topic_slugs.map { |slug_title| Topic.where(slug_title: slug_title).first }
      end

      def topic_slugs
        key.zrevrange(0, nr-1)
      end
    end
  end
end
