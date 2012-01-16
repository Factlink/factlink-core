class EvidenceController < FactsController

  before_filter :authenticate_user!, :except => [:index]

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.evidence(relation)

    respond_with(@evidence.map {|fr| FactRelations::FactRelation.for(fact_relation: fr, view: view_context)})
  end

  def create
    type          = relation
    fact_id       = params[:fact_id]
    displaystring = params[:displaystring]
    evidence_id   = params[:evidence_id]

    @fact = Fact[fact_id]

    if displaystring != nil
      # Create the evidence
      @evidence = create_fact(nil, displaystring, nil)
      evidence_id = @evidence.id
    else
      @evidence = Fact[evidence_id]
    end

    # Create the relation
    @fact_relation = add_evidence(evidence_id, type, fact_id)

    respond_to do |format|
      format.json { render json: FactRelations::FactRelation.for(fact_relation: @fact_relation, view: view_context) }
    end
  end

  def set_opinion
    type = params[:type].to_sym
    evidence = Basefact[params[:id]]

    authorize! :opinionate, evidence

    evidence.add_opinion(type, current_user.graph_user)
    evidence.calculate_opinion(2)

    render json: [FactRelations::FactRelation.for(fact_relation: evidence, view: view_context)]
  end

  def remove_opinions
    evidence = Basefact[params[:id]]

    authorize! :opinionate, evidence

    evidence.remove_opinions(current_user.graph_user)
    evidence.calculate_opinion(2)

    render json: [FactRelations::FactRelation.for(fact_relation: evidence, view: view_context)]
  end

  private
  def relation
    :both
  end
end