module Queries
  module Channels
    class Facts
      include Pavlov::Query

      arguments :id, :from, :count

      def execute
        channel = query(:'channels/get', id: id)

        options = {reversed: true, withscores: true, count: count}

        limit = from || 'inf'

        channel.sorted_cached_facts.below(limit, options)
      end
    end
  end
end
