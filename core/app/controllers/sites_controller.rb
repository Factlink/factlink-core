class SitesController < ApplicationController

  def facts_count_for_url
    site = Site.find(:url => params[:url]).first
    
    count = 0
    if site
      count = site.fact_count
    end
    
    render :json => { :count => count }, :callback => params[:callback], :content_type => "application/javascript"
  end

  def facts_for_url
    url = params[:url]
    site = Site.find(:url => url).first

    @facts = if site
    then site.facts.to_a
    else []
    end

    # Render the result with callback,
    # so JSONP can be used (for Internet Explorer)
    render :json => @facts , :callback => params[:callback], :content_type => "application/javascript"
  end
end
