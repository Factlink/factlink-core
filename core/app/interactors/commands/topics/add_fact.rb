module Commands
  module Topics
    class AddFact
      include Pavlov::Command

      arguments :fact_id, :topic_slug_title

      def execute
        redis_key.zadd score, @fact_id
      end

      def redis_key
        Nest.new(:new_topic)[@topic_slug_title][:facts]
      end

      def score
        (DateTime.now.to_time.to_f*1000).to_i
      end

      def validate
        validate_integer  :fact_id, @fact_id
        validate_string   :topic_slug_title, @topic_slug_title
      end
    end
  end
end
