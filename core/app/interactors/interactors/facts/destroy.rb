module Interactors
  module Facts
    class Destroy
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def authorized?
        can? :manage, Fact
      end

      private

      def execute
        return if fact.evidence_count > 0

        command :'facts/destroy', fact_id: fact_id
      end

      def fact
        @fact ||= query :'facts/get_dead', id: fact_id
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end

    end
  end
end
