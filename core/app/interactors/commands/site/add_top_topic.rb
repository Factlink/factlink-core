module Commands
  module Site
    class AddTopTopic
      include Pavlov::Command

      arguments :site_id, :topic_slug

      def execute
        increase_topic_by topic_slug, 1
      end

      def increase_topic_by topic_id, score
        key.zincrby score, topic_id
      end

      def key
        redis[site_id][:top_topics]
      end

      def redis
        Nest.new(:site,Redis.current)
      end
    end
  end
end
