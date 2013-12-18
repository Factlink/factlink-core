module Interactors
  module Facts
    class Opinionators
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :type

      def execute
        interacting_users = query(:'facts/interacting_users',
                                      fact_id: fact_id,
                                      opinion: type)

        interacting_users.merge(type: type)
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
