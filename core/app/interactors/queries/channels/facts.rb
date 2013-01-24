require 'pavlov'

module Queries
  module Channels
    class Facts
      include Pavlov::Query

      arguments :id, :from, :count

      def execute
        channel = query :'channels/get', @id

        @options[:reversed] = true
        @options[:withscores] = true
        @options[:count] = @count

        limit = @from || 'inf'
        channel.sorted_cached_facts.below(limit, @options)
      end

      def validate
        validate_integer :from, @from
        validate_integer :count, @count
        validate_integer_string :id, @id
      end
    end
  end
end
