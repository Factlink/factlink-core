class EvidenceController < FactsController
  
  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.evidence(relation).map{|fr| fr.fact }

    render :json => @evidence
  end

  private
  def relation
    :both
  end
end