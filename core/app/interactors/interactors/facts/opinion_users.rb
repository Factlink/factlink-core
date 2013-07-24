require 'pavlov'

module Interactors
  module Facts
    class OpinionUsers
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :skip, :take, :type, :pavlov_options

      def execute
        interacting_users = old_query :'facts/interacting_users', fact_id, skip, take, type
        interacting_users[:impact] = old_query :'opinions/interacting_users_impact_for_fact', fact_id, type
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
