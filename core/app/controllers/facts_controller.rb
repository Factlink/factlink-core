class FactsController < ApplicationController
  pavlov_action :show, Interactors::Facts::Get

  def discussion_page_redirect
    dead_fact = interactor(:'facts/get', id: params[:id])

    redirect_to FactUrl.new(dead_fact).proxy_open_url, status: :moved_permanently
  end

  def create
    dead_fact = interactor(:'facts/create',
                           displaystring: params[:displaystring].to_s,
                           url: params[:url].to_s,
                           site_title: params[:site_title].to_s)

    render json: dead_fact
  end

  def search
    facts = interactor(:'facts/search', keywords: params[:keywords])

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
