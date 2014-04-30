module Interactors
  module Facts
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def execute
        Backend::Facts.get(fact_id: id)
      end

      def authorized?
        can? :read, FactData.where(fact_id: id).first
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
