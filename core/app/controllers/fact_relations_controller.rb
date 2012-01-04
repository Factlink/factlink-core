class FactRelationsController < ApplicationController

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.sorted_fact_relations
    
    respond_with(@evidence.map { |evidence|
      Facts::FactBubble.for_fact_and_view(evidence.from_fact, view_context).to_json
    })
  end

end