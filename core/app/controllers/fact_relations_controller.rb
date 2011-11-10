class FactRelationsController < ApplicationController

  # fact_evidence_index
  # /facts/:fact_id/evidence(.:format)
  def index    
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.sorted_fact_relations

    respond_to do |format|
      format.js
      format.json { render :json => [@fact.sorted_fact_relations] }
    end
  end
  
end