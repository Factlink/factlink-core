require_relative '../../pavlov'

module Interactors
  module Evidence
    class Index
      include Pavlov::Interactor

      arguments :fact_id, :type

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_integer_string :fact_id, @fact_id
        validate_in_set         :type,    @type, [:weakening, :supporting]
      end

      def execute
        query :'evidence/index', @fact_id, @type
      end
    end
  end
end
