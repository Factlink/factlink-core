class ClientController < ApplicationController
  def blank
    render_client
  end

  def facts_new
    render_client
  end

  def fact_show
    fact = interactor(:'facts/get', id: params[:id]) or raise_404
    authorize! :show, fact
    render_client
  end

  private

  def render_client
    render inline: '', layout: 'client'
  end
end
