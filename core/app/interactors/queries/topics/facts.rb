require 'active_support/core_ext/object/blank'

module Queries
  module Topics
    class Facts
      include Pavlov::Query

      arguments :slug_title, :count, :max_timestamp

      def setup_defaults
        @max_timestamp = 'inf' if @max_timestamp.blank?
      end

      def execute
        setup_defaults

        results = Ohm::Model::SortedSet.hash_array_for_withscores facts_with_scores_interleaved_array

        results.map {|item| {score: item[:score], item: Fact[item[:item]]}}
      end

      def facts_with_scores_interleaved_array
        redis_key.zrevrangebyscore("(#{@max_timestamp}", '-inf', redis_opts)
      end

      def redis_opts
        {withscores: true, limit: [0, @count]}
      end

      def redis_key
        Topic.redis[@slug_title][:facts]
      end

      def validate
        validate_string   :slug_title, @slug_title
        validate_integer  :count, @count
        validate_integer  :max_timestamp, @max_timestamp, allow_blank: true
      end
    end
  end
end
