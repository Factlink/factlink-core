class FactRelationsController < ApplicationController

  respond_to :json, :js

  # fact_evidence_index
  # /facts/:fact_id/evidence(.:format)
  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.sorted_fact_relations

    respond_with(@fact.sorted_fact_relations)
  end
  
end