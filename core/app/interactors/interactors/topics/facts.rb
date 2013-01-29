require 'active_support/core_ext/object/blank'

module Interactors
  module Topics
    class Facts
      include Pavlov::Query

      arguments :topic_id, :count, :max_timestamp

      def setup_defaults
        @count = 7 if @count.blank?
      end

      def execute
        setup_defaults

        query :'topics/facts', @topic_id, @count, @max_timestamp
      end

      def validate
        validate_hexadecimal_string :topic_id, @topic_id
        validate_integer            :count, @count, allow_blank: true
        validate_integer            :max_timestamp, @max_timestamp, allow_blank: true
      end
    end
  end
end
