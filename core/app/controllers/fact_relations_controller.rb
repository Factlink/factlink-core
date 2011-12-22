class FactRelationsController < ApplicationController

  respond_to :json, :js

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.sorted_fact_relations

    respond_with(@fact.sorted_fact_relations)
  end

end