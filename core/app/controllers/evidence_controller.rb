class EvidenceController < FactsController

  before_filter :authenticate_user!, except: [:index]

  respond_to :json

  def combined_index
    @evidence = interactor :"evidence/for_fact_id", params[:fact_id], relation

    render 'evidence/index'
  end

  class EvidenceNotFoundException < StandardError
  end

  def create_new_evidence(displaystring, opinion)
    evidence = Fact.build_with_data(nil, displaystring.to_s, nil, current_graph_user)

    (evidence.data.save and evidence.save) or raise EvidenceNotFoundException
    if opinion
      evidence.add_opinion(opinion, current_graph_user)
      Activity::Subject.activity(current_graph_user, Opinion.real_for(opinion),evidence)
    end

    evidence
  end

  def retrieve_evidence(evidence_id)
    Fact[evidence_id] or raise EvidenceNotFoundException
  end

  #TODO move to a fact_relation resource
  def create
    fact = Fact[params[:fact_id]]

    authorize! :add_evidence, fact

    if params[:displaystring] != nil
      @evidence = create_new_evidence params[:displaystring], params[:from_fact].andand[:opinion]
    else
      @evidence = retrieve_evidence params[:evidence_id]
    end

    @fact_relation = create_believed_factrelation(@evidence, relation, fact)

    @fact_relation.calculate_opinion

    render 'fact_relations/show'
  rescue EvidenceNotFoundException
    render json: [], status: :unprocessable_entity
  end

  def set_opinion
    type = params[:type].to_sym

    @fact_relation = FactRelation[params[:id]]

    authorize! :opinionate, @fact_relation

    @fact_relation.add_opinion(type, current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user, Opinion.real_for(type),@fact_relation)

    @fact_relation.calculate_opinion

    render 'fact_relations/show'
  end

  def remove_opinions
    @fact_relation = Basefact[params[:id]]

    authorize! :opinionate, @fact_relation

    @fact_relation.remove_opinions(current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user,:removed_opinions,@fact_relation)

    @fact_relation.calculate_opinion

    render 'fact_relations/show'
  end

  #TODO move to a fact_relation resource
  def destroy
    fact_relation = FactRelation[params[:id]]

    authorize! :destroy, fact_relation

    fact_relation.delete

    respond_to do |format|
      format.json  { render :json => {}, :status => :ok }
    end
  end

  private
    # TODO This should not be a Controller method. Move to FactRelation
    def create_believed_factrelation(evidence, type, fact)
      type     = type.to_sym

      # Create FactRelation
      fact_relation = fact.add_evidence(type, evidence, current_user)
      fact_relation.add_opinion(:believes, current_graph_user)
      Activity::Subject.activity(current_graph_user, Opinion.real_for(:believes),fact_relation)

      fact_relation
    end
end
