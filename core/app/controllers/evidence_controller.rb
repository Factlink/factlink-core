class EvidenceController < FactsController

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.evidence(relation).map{|fr| fr.fact }

    respond_with(@evidence)
  end

  private
  def relation
    :both
  end
end