module Queries
  module Facts
    class Get
      include Pavlov::Query

      arguments :id
      attribute :pavlov_options, Hash, default: {}

      def execute
        Fact[id]
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
