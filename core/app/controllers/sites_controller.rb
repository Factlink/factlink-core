class SitesController < ApplicationController

  def facts_count_for_url
    facts = retrieve_facts_for_url(params[:url])
    count = facts.count
    render :json => { :count => count }, :callback => params[:callback], :content_type => "application/javascript"
  end

  def facts_for_url
    facts = retrieve_facts_for_url(params[:url])
    # Render the result with callback,
    # so JSONP can be used (for Internet Explorer)
    render :json => facts , :callback => params[:callback], :content_type => "application/javascript"
  end
  
  private
  def retrieve_facts_for_url(url)
    url = params[:url]
    site = Site.find(:url => url).first
    return site ? site.facts.to_a : []
  end
end
