class SitesController < ApplicationController
  def facts_for_url
    render_jsonp Backend::Facts.for_url(site_url: params[:url])
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
