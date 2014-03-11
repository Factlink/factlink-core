class FactsController < ApplicationController
  layout "client"

  respond_to :json, :html

  before_filter :load_fact,
    only: [
      :show,
      :discussion_page,
      :discussion_page_redirect,
      :destroy,
      :update,
      :opinion,
      :evidence_search,
      :share
      ]

  def show
    authorize! :show, Fact
    dead_fact = query(:'facts/get_dead', id: @fact.id.to_s)
    render json: dead_fact
  end

  def discussion_page
    authorize! :show, Fact

    backbone_responder
  end

  def discussion_page_redirect
    authorize! :show, Fact

    redirect_to FactUrl.new(@fact).proxy_open_url, status: :moved_permanently
  end

  def create
    authorize! :create, Fact

    dead_fact = interactor(:'facts/create',
                           displaystring: params[:displaystring].to_s,
                           url: params[:url].to_s,
                           title: params[:site_title].to_s)

    render json: dead_fact
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]

    raise_404 if Fact.invalid(@fact)
    facts = interactor(:'search_evidence', keywords: search_for, fact_id: @fact.id)

    render json: facts
  end

  def recently_viewed
    @facts = interactor :"facts/recently_viewed"

    render json: @facts.map { |f| query(:'facts/get_dead', id: f.id.to_s) }
  end

  def share
    authorize! :share, @fact

    interactor :'facts/social_share', fact_id: @fact.id,
      message: params[:message], provider_names: params[:provider_names]

    render json: {}
  end

  private

  def load_fact
    fact_id = params[:fact_id] || params[:id]
    @fact = interactor(:'facts/get', id: fact_id) or raise_404
  end
end
