module Queries
  module Channels
    class Facts
      include Pavlov::Query

      arguments :id, :from, :count

      def execute
        channel = query(:'channels/get', id: id)

        query :'facts/get_paginated',
              key: channel.sorted_cached_facts.key.to_s,
              from: from,
              count: count
      end
    end
  end
end
