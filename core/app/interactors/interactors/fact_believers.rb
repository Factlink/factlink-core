require_relative '../pavlov'

module Interactors
class FactBelievers
  include Pavlov::Interactor

  arguments :fact_id, :skip, :take

  def execute
    query :fact_interacting_users, @fact_id, @skip, @take, 'believes'
  end

  def authorized?
    @options[:current_user]
  end
end
end
