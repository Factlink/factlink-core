require 'active_support/core_ext/object/blank'

module Queries
  module Topics
    class Facts
      include Pavlov::Query

      arguments :topic_id, :count, :max_timestamp

      def setup_defaults
        @max_timestamp = 'inf' if @max_timestamp.blank?
      end

      def execute
        setup_defaults

        Ohm::Model::SortedSet.hash_array_for_withscores facts_with_scores_interleaved_array
      end

      def facts_with_scores_interleaved_array
        redis_key.zrevrangebyscore("(#{@max_timestamp}", '-inf', redis_opts)
      end

      def redis_opts
        {withscores: true, limit: [0, @count]}
      end

      def redis_key
        Nest.new(:new_topic)[@topic_id][:facts]
      end

      def validate
        validate_hexadecimal_string :topic_id, @topic_id
        validate_integer            :count, @count
        validate_integer            :max_timestamp, @max_timestamp, allow_blank: true
      end
    end
  end
end
