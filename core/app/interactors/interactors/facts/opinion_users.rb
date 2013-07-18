require 'pavlov'

module Interactors
  module Facts
    class OpinionUsers
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :skip, :take, :type

      def execute
        interacting_users = query :'facts/interacting_users', fact_id, skip, take, type
        interacting_users[:impact] = query :'facts/interacting_users_impact', fact_id, type
        interacting_users[:type] = type

        interacting_users
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
