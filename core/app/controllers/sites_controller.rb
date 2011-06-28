class SitesController < ApplicationController

  before_filter :authenticate_admin!, :except => [:count_for_site]

  def count_for_site
    site = Site.first(:conditions => { :url => params[:url] })
    
    count = 0
    if site
      count = site.factlink_count
    end
    
    render :json => { :count => count }, :callback => params[:callback]
  end

end
