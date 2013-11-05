module Queries
  module Facts
    class GetPaginated
      include Pavlov::Query

      arguments :key, :from, :count

      def execute
        options = {
          reversed: true,
          withscores: true,
          count: count
        }
        limit = from || 'inf'
        timestamped_set_for(key_for_string(key)).below(limit, options)
      end

      def timestamped_set_for(key)
        Ohm::Model::TimestampedSet.new(key, Ohm::Model::Wrapper.wrap(Fact))
      end

      def key_for_string(string)
        Ohm::Key.new(string, Ohm.redis)
      end
    end
  end
end
