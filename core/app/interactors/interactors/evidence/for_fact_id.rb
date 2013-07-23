require 'pavlov'

module Interactors
  module Evidence
    class ForFactId
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :type

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer_string :fact_id, @fact_id
        validate_in_set         :type,    @type, [:weakening, :supporting]
      end

      def execute
        old_query :'evidence/for_fact_id', @fact_id, @type
      end
    end
  end
end
