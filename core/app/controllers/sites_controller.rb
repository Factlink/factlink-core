class SitesController < ApplicationController

  before_filter :authenticate_admin!, :except => [:count_for_site]

  def count_for_site
    site = Site.find(:url => params[:url])[0]
    
    count = 0
    if site
      count = site.fact_count
    end
    
    render :json => { :count => count }, :callback => params[:callback]
  end

end
