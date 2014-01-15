class EvidenceController < ApplicationController

  before_filter :authenticate_user!, except: [:index]

  respond_to :json

  def index
    @evidence = interactor(:'evidence/for_fact_id', fact_id: params[:fact_id])

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
    raise 'FactRelations do not exist anymore!'

    fact = Fact[params[:fact_id]]

    authorize! :add_evidence, fact

    evidence = Fact[params[:evidence_id]] or fail EvidenceNotFoundException

    @fact_relation = create_believed_factrelation(evidence, params[:type], fact)

    render 'fact_relations/show', formats: [:json]
  rescue EvidenceNotFoundException
    render json: [], status: :unprocessable_entity
  end

  def update_opinion
    raise 'FactRelations do not exist anymore!'

    @fact_relation = FactRelation[params[:id]]
    authorize! :opinionate, @fact_relation

    if params[:current_user_opinion] == 'no_vote'
      @fact_relation.remove_opinions(current_user.graph_user)
    else
      type = params[:current_user_opinion]
      @fact_relation.add_opinion(type, current_user.graph_user)
      Activity.create user: current_user.graph_user, action: type, subject: @fact_relation
    end

    render 'fact_relations/show', formats: [:json]
  end

  # TODO move to a fact_relation resource
  def destroy
    raise 'FactRelations do not exist anymore!'

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
    Activity.create user: current_graph_user, action: :believes, subject: fact_relation

    fact_relation
  end

end
