class FactsController < ApplicationController
  layout "client"

  respond_to :json, :html

  def show
    dead_fact = interactor(:'facts/get', id: params[:id])

    render json: dead_fact
  end

  def discussion_page_redirect
    dead_fact = interactor(:'facts/get', id: params[:id])

    redirect_to FactUrl.new(dead_fact).proxy_open_url, status: :moved_permanently
  end

  def create
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
    facts = interactor(:'search_evidence', keywords: params[:s], fact_id: params[:id])

    render json: facts
  end

  def recently_viewed
    facts = interactor :"facts/recently_viewed"

    render json: facts
  end

  def share
    interactor :'facts/social_share', fact_id: params[:id],
      message: params[:message], provider_names: params[:provider_names]

    render json: {}
  end
end
