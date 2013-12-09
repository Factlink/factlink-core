class EvidenceController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :combined_index]

  respond_to :json

  def combined_index
    @evidence = interactor(:'evidence/for_fact_id',
                               fact_id: params[:fact_id],type: relation)

    render 'evidence/index', formats: [:json]
  end

  class EvidenceNotFoundException < StandardError
  end

  def show
    @fact_relation = interactor(:'fact_relations/by_id', fact_relation_id: params[:id].to_s)

    render 'fact_relations/show', formats: [:json]
  end

  # TODO move to a fact_relation resource
  def create
    fact = Fact[params[:fact_id]]

    authorize! :add_evidence, fact

    evidence = Fact[params[:evidence_id]] or fail EvidenceNotFoundException

    @fact_relation = create_believed_factrelation(evidence, relation, fact)

    render 'fact_relations/show', formats: [:json]
  rescue EvidenceNotFoundException
    render json: [], status: :unprocessable_entity
  end

  def update_opinion
    @fact_relation = FactRelation[params[:id]]
    authorize! :opinionate, @fact_relation

    if params[:current_user_opinion] == 'no_vote'
      @fact_relation.remove_opinions(current_user.graph_user)
    else
      type = OpinionType.real_for(params[:current_user_opinion])
      @fact_relation.add_opinion(type, current_user.graph_user)
      Activity::Subject.activity(current_user.graph_user, type, @fact_relation)
    end

    render 'fact_relations/show', formats: [:json]
  end

  # TODO move to a fact_relation resource
  def destroy
    fact_relation = FactRelation[params[:id]]

    authorize! :destroy, fact_relation

    fact_relation.delete

    render json: {}, status: :ok
  end

  private

  # TODO This should not be a Controller method. Move to FactRelation
  def create_believed_factrelation(evidence, type, fact)
    # Create FactRelation
    fact_relation = fact.add_evidence(type, evidence, current_user)
    fact_relation.add_opinion(:believes, current_graph_user)
    Activity::Subject.activity(current_graph_user, OpinionType.real_for(:believes),fact_relation)

    fact_relation
  end
end
