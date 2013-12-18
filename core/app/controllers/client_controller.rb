class ClientController < ApplicationController
  def blank
    render_client
  end

  def facts_new
    render_client
  end

  def fact_show
    render_client
  end

  private

  def render_client
    render inline: '', layout: 'client'
  end
end
