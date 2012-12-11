class EvidenceController < FactsController

  before_filter :authenticate_user!, :except => [:index]

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]] || raise_404("Fact not found")
    @evidence = @fact.evidence(relation)

    authorize! :get_evidence, @fact

    @fact_relations = @evidence.to_a.sort do |a,b|
      OpinionPresenter.new(b.get_user_opinion).relevance <=> OpinionPresenter.new(a.get_user_opinion).relevance
    end

    render 'fact_relations/index'
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

  def create
    fact = Fact[params[:fact_id]]

    authorize! :add_evidence, fact

    if params[:displaystring] != nil
      @evidence = create_new_evidence params[:displaystring], params[:fact_base].andand[:opinion]
    else
      @evidence = retrieve_evidence params[:evidence_id]
    end

    @fact_relation = create_believed_factrelation(@evidence, relation, fact)
    fact.calculate_opinion(2)

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

    @fact_relation.calculate_opinion(2)

    render 'fact_relations/show'
  end

  def remove_opinions
    @fact_relation = Basefact[params[:id]]

    authorize! :opinionate, @fact_relation

    @fact_relation.remove_opinions(current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user,:removed_opinions,@fact_relation)

    @fact_relation.calculate_opinion(2)

    render 'fact_relations/show'
  end

  def destroy
    fact_relation = FactRelation[params[:id]]

    authorize! :destroy, fact_relation

    fact_relation.delete

    respond_to do |format|
      format.json  { render :json => {}, :status => :ok }
    end
  end

  private
    def relation
      :both
    end
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
