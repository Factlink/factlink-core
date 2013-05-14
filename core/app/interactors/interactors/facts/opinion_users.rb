require 'pavlov'

module Interactors
  module Facts
    class OpinionUsers
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :skip, :take, :type

      def execute
        query :fact_interacting_users, fact_id, skip, take, type
      end

      def authorized?
        can? :show, Fact
      end
    end
  end
end
