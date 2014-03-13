class FactsController < ApplicationController
  pavlov_action :show, Interactors::Facts::Get
  pavlov_action :create, Interactors::Facts::Create
  pavlov_action :search, Interactors::Facts::Search
  pavlov_action :recently_viewed, Interactors::Facts::RecentlyViewed
  pavlov_action :share, Interactors::Facts::SocialShare

  def discussion_page_redirect
    dead_fact = interactor(:'facts/get', id: params[:id])

    redirect_to FactUrl.new(dead_fact).proxy_open_url, status: :moved_permanently
  end
end
