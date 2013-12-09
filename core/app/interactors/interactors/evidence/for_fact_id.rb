module Interactors
  module Evidence
    class ForFactId
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end

      def execute
        query :'evidence/for_fact_id', fact_id: fact_id
      end
    end
  end
end
