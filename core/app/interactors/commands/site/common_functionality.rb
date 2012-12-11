require 'nest'

module Commands
  module Site
    module CommonFunctionality

      def increase_topic_by topic_id, score
        key.zincrby score, topic_id
      end

      def key
        redis[@site_id][:top_topics]
      end

      def redis
        Nest.new(:site,Redis.current)
      end

    end
  end
end
