module Interactors
  module Facts
    class OpinionUsers
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :skip, :take, :type

      def execute
        interacting_users = query(:'facts/interacting_users',
                                      fact_id: fact_id, skip: skip, take: take,
                                      opinion: type)

        interacting_users.merge(type: type)
      end

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer :fact_id, fact_id
        validate_integer :skip,    skip
        validate_integer :take,    take
        validate_in_set  :type,    type, ['believes','disbelieves','doubts']
      end
    end
  end
end
