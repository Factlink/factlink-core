require 'active_support/core_ext/object/blank'

module Commands
  module Topics
    class AddFact
      include Pavlov::Command

      arguments :fact_id, :topic_slug_title, :score

      def execute
        redis_key.zadd score, @fact_id
      end

      def score
        @score = nil if @score.blank? # because '' is not falsey
        Ohm::Model::TimestampedSet.current_time(@score)
      end

      def redis_key
        Topic.redis[@topic_slug_title][:facts]
      end

      def validate
        validate_integer_string  :fact_id, @fact_id
        validate_string          :topic_slug_title, @topic_slug_title
        validate_string          :score, @score
      end
    end
  end
end
