require 'redis/aid'

module Commands
  module Site
    class AddTopTopic
      include Pavlov::Command
      include Redis::Aid::Ns(:site)

      arguments :site_id, :topic_id

      def execute
        key.zincrby 1, @topic_id
      end

      def key
        redis[@site_id][:top_topics]
      end

      def validate
        validate_integer :site_id, @site_id
        validate_hexadecimal_string :topic_id, @topic_id
      end
    end
  end
end
