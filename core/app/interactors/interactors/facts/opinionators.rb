module Interactors
  module Facts
    class Opinionators
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :type

      def execute
        query(:'facts/opinionators', fact_id: fact_id, opinion: type)
      end

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer :fact_id, fact_id
        validate_in_set  :type,    type, ['believes','disbelieves','doubts']
      end
    end
  end
end
