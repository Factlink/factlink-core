require 'pavlov'

module Interactors
  module Evidence
    class ForFactId
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :type

      def authorized?
        can? :show, fact
      end

      def validate
        validate_integer_string :fact_id, @fact_id
        validate_in_set         :type,    @type, [:weakening, :supporting]
      end

      def execute
        query :'evidence/for_fact_id', @fact_id, @type
      end

      def fact
        @fact ||= ::Fact[fact_id]
      end
    end
  end
end
