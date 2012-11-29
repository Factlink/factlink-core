require_relative '../pavlov'

module Interactors
class FactDoubters
  include Pavlov::Interactor

  arguments :fact_id, :skip, :take

  def execute
    query :fact_interacting_users, @fact_id, @skip, @take, 'doubts'
  end

  def authorized?
    @options[:current_user]
  end
end
end
