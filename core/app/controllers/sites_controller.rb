class SitesController < ApplicationController
  before_filter :check_blacklist, :only => [
      :facts_count_for_url
    ]
  
  def facts_count_for_url
    facts = retrieve_facts_for_url(params[:url])
    count = facts.count

    render :json => { :count => count }, :callback => params[:callback], :content_type => "application/javascript"
  end

  def facts_for_url
    facts = retrieve_facts_for_url(params[:url])

    render :json => facts , :callback => params[:callback], :content_type => "application/javascript"
  end
  
  private
  def retrieve_facts_for_url(url)
    url = params[:url]
    site = Site.find(:url => url).first
    return site ? site.facts.to_a : []
  end
  
  def check_blacklist
    if Blacklist.default.matches? params[:url]
      render :json => { :blacklisted => true }, :callback => params[:callback], :content_type => "application/javascript"
    end
  end
end
