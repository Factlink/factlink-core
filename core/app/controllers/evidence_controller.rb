class EvidenceController < FactsController
  
  before_filter :authenticate_user!, :except => [:index]
  
  respond_to :json, :js

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.evidence(relation).map{|fr| fr.from_fact }

    respond_with(@evidence)
  end

  def create
    type          = params[:type]
    fact_id       = params[:fact_id]    
    displaystring = params[:displaystring]

    @fact = Fact[params[:fact_id]]
    
    # Create the evidence
    @evidence = create_fact(nil, displaystring, nil)
    evidence_id = @evidence.id

    # Create the relation
    @fact_relation = add_evidence(evidence_id, type, fact_id)

    respond_to do |format|
      format.json { render json: @fact_relation }
      format.js   { render layout: false, partial: "facts/add_evidence_as_li" }
    end
  end

  private
  def relation
    :both
  end
end