module Commands
  module Topics
    class AddFact
      include Pavlov::Command

      arguments :fact_id, :topic_id

      def execute
        redis_key.zadd score, @fact_id
      end

      def redis_key
        Nest.new(:new_topic)[@topic_id][:facts]
      end

      def score
        (DateTime.now.to_time.to_f*1000).to_i
      end

      def validate
        validate_integer            :fact_id, @fact_id
        validate_hexadecimal_string :topic_id, @topic_id
      end
    end
  end
end
