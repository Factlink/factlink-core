module Commands
  module Topics
    class AddFact
      include Pavlov::Command

      arguments :fact_id, :topic_slug_title, :score

      def execute
        redis_key.zadd @score, @fact_id
      end

      def redis_key
        Topic.redis[@topic_slug_title][:facts]
      end

      def validate
        validate_integer  :fact_id, @fact_id
        validate_string   :topic_slug_title, @topic_slug_title
        validate_integer  :score, @score
      end
    end
  end
end
