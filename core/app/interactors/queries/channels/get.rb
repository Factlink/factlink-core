require 'pavlov'

module Queries
  module Channels
    class Get
      include Pavlov::Query

      arguments :id

      def execute
        Channel[@id]
      end

      def validate
        validate_integer_string :id, @id
      end
    end
  end
end
