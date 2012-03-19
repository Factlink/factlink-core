class EvidenceController < FactsController

  before_filter :authenticate_user!, :except => [:index]

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]]
    @evidence = @fact.evidence(relation)

    authorize! :get_evidence, @fact

    respond_with(@evidence.map {|fr| FactRelations::FactRelation.for(fact_relation: fr, view: view_context)})
  end

  def create
    @fact = Fact[params[:fact_id]]

    authorize! :add_evidence, @fact

    if params[:displaystring] != nil
      @evidence = create_fact(nil, params[:displaystring], nil)
      @evidence.add_opinion(:believes, current_graph_user)
    else
      @evidence = Fact[params[:evidence_id]]
    end

    @fact_relation = create_believed_factrelation(@evidence, relation, @fact)

    @fact.calculate_opinion(2)

    respond_to do |format|
      format.json { render json: FactRelations::FactRelation.for(fact_relation: @fact_relation, view: view_context) }
    end
  end

  def set_opinion
    type = params[:type].to_sym

    fact_relation = FactRelation[params[:id]]

    authorize! :opinionate, fact_relation

    fact_relation.add_opinion(type, current_user.graph_user)
    fact_relation.calculate_opinion(2)

    render json: [FactRelations::FactRelation.for(fact_relation: fact_relation, view: view_context)]
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
    # TODO This should not be a Controller method. Move to FactRelation
    def create_believed_factrelation(evidence, type, fact) # private
      type     = type.to_sym

      # Create FactRelation
      fact_relation = fact.add_evidence(type, evidence, current_user)
      fact_relation.add_opinion(:believes, current_graph_user)


      fact_relation
    end
end