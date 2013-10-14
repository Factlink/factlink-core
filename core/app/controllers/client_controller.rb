class ClientController < ApplicationController
  def blank
    render_client
  end

  def intermediate
    render layout: nil
  end

  def facts_new
    authorize! :new, Fact
    authenticate_user!

    render_client
  end

  def fact_show
    fact = interactor(:'facts/get', id: params[:id]) or raise_404
    authorize! :show, fact

    # TODO: determine if we still want this here..?
    dead_fact = query(:'facts/get_dead', id: params[:id])
    open_graph_fact = OpenGraph::Objects::OgFact.new dead_fact
    open_graph_formatter.add open_graph_fact

    render_client
  end

  private

  def render_client
    render inline: '', layout: 'client'
  end
end
