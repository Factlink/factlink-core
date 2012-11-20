class EvidenceController < FactsController

  before_filter :authenticate_user!, :except => [:index]

  respond_to :json

  def index
    @fact = Fact[params[:fact_id]] || raise_404("Fact not found")
    @evidence = @fact.evidence(relation)

    authorize! :get_evidence, @fact

    @fact_relations = @evidence
    render 'fact_relations/index'
  end

  def create
    fact = Fact[params[:fact_id]]

    authorize! :add_evidence, fact

    if params[:displaystring] != nil
      @evidence = Fact.build_with_data(nil, params[:displaystring].to_s, nil, current_graph_user)
      @evidence_saved = @evidence.data.save and @evidence.save
      @evidence.add_opinion(:believes, current_graph_user) if @evidence_saved
    else
      @evidence = Fact[params[:evidence_id]]
      @evidence_saved = true
    end


    respond_to do |format|
      if @evidence_saved
        @fact_relation = create_believed_factrelation(@evidence, relation, fact)
        fact.calculate_opinion(2)

        format.json do
          render 'fact_relations/show'
        end
      else
        format.json { render json: [], status: :unprocessable_entity }
      end
    end
  end

  def set_opinion
    type = params[:type].to_sym

    @fact_relation = FactRelation[params[:id]]

    authorize! :opinionate, @fact_relation

    @fact_relation.add_opinion(type, current_user.graph_user)
    @fact_relation.calculate_opinion(2)

    render 'fact_relations/show'
  end

  def remove_opinions
    @fact_relation = Basefact[params[:id]]

    authorize! :opinionate, @fact_relation

    @fact_relation.remove_opinions(current_user.graph_user)
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


      fact_relation
    end
end
