require_relative '../../../classes/hash_utils'

module Queries
  module UserTopics
    class LastUsedForUser
      include Pavlov::Query
      include HashUtils

      arguments :user_id

      private

      def validate
        validate_hexadecimal_string :user_id, user_id
      end

      def execute
        []
      end
    end
  end
end
