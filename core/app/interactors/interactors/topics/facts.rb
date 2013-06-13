require 'active_support/core_ext/object/blank'

module Interactors
  module Topics
    class Facts
      include Pavlov::Interactor

      arguments :slug_title, :count, :max_timestamp

      def setup_defaults
        @count = 7 if @count.blank?
      end

      def execute
        setup_defaults

        query :'topics/facts', @slug_title, @count, @max_timestamp
      end

      def validate
        validate_string   :slug_title, @slug_title
        validate_integer  :count, @count, allow_blank: true
        validate_integer  :max_timestamp, @max_timestamp, allow_blank: true
      end

      def authorized?
        not @options[:current_user].blank?
      end
    end
  end
end
