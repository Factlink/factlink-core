require 'pavlov'

module Interactors
  module Facts
    class OpinionUsers
      include Pavlov::Interactor

      arguments :fact_id, :skip, :take, :type

      def execute
        query :fact_interacting_users, @fact_id, @skip, @take, @type
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
