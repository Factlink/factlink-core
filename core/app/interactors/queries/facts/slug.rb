module Queries
  module Facts
    class SharingUrl
      include Pavlov::Query

      arguments :fact, :max_slug_length

      def execute
        return fact.id if fact.to_s.blank?

        max_slug_length ||= 1024
        fact.to_s.parameterize.slice(0, max_slug_length)
      end

      def validate
        validate_not_nil :fact, fact

        validate_integer :max_slug_length, max_slug_length unless max_slug_length.nil?
      end
    end
  end
end
