class FactsController < ApplicationController
  def discussion_page_redirect
    dead_fact = interactor(:'facts/get', id: params[:id])

    redirect_to FactUrl.new(dead_fact).proxy_open_url, status: :moved_permanently
  end
end
