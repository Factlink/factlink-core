require 'active_support/core_ext/object/blank'

module Queries
  module Facts
    class Slug
      include Pavlov::Query

      arguments :fact, :max_slug_length_in
      attribute :pavlov_options, Hash, default: {}

      private

      def execute
        return fact.id if fact.to_s.blank?

        fact.to_s.parameterize[0, max_slug_length]
      end

      def validate
        validate_not_nil :fact, fact
        validate_integer :max_slug_length, max_slug_length
      end

      def max_slug_length
        max_slug_length_in || 1024
      end
    end
  end
end
