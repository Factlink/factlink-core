require 'pavlov'

module Interactors
  class FactDisbelievers
    include Pavlov::Interactor

    arguments :fact_id, :skip, :take

    def execute
      query :fact_interacting_users, @fact_id, @skip, @take, 'disbelieves'
    end

    def authorized?
      @options[:current_user]
    end
  end
end
