class SitesController < ApplicationController
  def facts_for_url
    url = params[:url]

    site = Site.find(url: url).first
    facts = site ? site.facts.to_a : []

    facts = facts.map do |fact|
      {
        id: fact.id,
        displaystring: fact.data.displaystring,
        title: fact.data.title
      }
    end

    render_jsonp facts
  end

  private

  def render_jsonp json_able
    if params[:callback]
      render json: json_able, callback: params[:callback], content_type: "application/javascript"
    else
      render json: json_able
    end
  end
end
