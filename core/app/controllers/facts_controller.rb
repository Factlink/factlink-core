class FactsController < ApplicationController
  layout "client"

  respond_to :json, :html

  before_filter :load_fact,
    only: [
      :show,
      :discussion_page,
      :destroy,
      :update,
      :opinion,
      :evidence_search,
      :update_opinion,
      :share
      ]

  def show
    authorize! :show, @fact

    render 'facts/show', formats: [:json]
  end

  def discussion_page
    authorize! :show, @fact

    backbone_responder
  end

  def create
    authenticate_user!
    authorize! :create, Fact

    @fact = interactor(:'facts/create',
                           displaystring: params[:displaystring].to_s,
                           url: params[:url].to_s,
                           title: params[:fact_title].to_s)
    @site = @fact.site

    mp_track_people_event last_factlink_created: DateTime.now

    render 'facts/show', formats: [:json]
  end

  def destroy
    authorize! :destroy, @fact

    interactor :'facts/destroy', fact_id: @fact.id

    render json: {}
  end

  def update_opinion
    authorize! :opinionate, @fact

    if params[:current_user_opinion] == 'no_vote'
      @fact.remove_opinions(current_user.graph_user)
    else
      type = params[:current_user_opinion]
      @fact.add_opinion(type, current_user.graph_user)
      Activity.create user: current_user.graph_user, action: type, subject: @fact
    end

    render json: {}
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]

    raise_404 if Fact.invalid(@fact)
    evidence = interactor(:'search_evidence', keywords: search_for, fact_id: @fact.id)
    @facts = evidence.map { |fd| fd.fact }

    render 'facts/index', formats: [:json]
  end

  def recently_viewed
    @facts = interactor :"facts/recently_viewed"

    render 'facts/index', formats: [:json]
  end

  def share
    authorize! :share, @fact

    interactor :'facts/social_share', fact_id: @fact.id,
      message: params[:message], provider_names: params[:provider_names]

    render json: {}
  end

  private

  def load_fact
    @fact = interactor(:'facts/get', id: fact_id) or raise_404
  end

  def fact_id
    params[:fact_id] || params[:id]
  end
end
