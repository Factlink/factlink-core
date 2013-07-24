module Queries
  module Facts
    class Get
      include Pavlov::Query

      arguments :id, :pavlov_options

      def execute
        Fact[id]
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
