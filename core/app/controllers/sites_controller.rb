class SitesController < ApplicationController

  before_filter :authenticate_user!, :except => [:highlights_for_site, :count_for_site]

  def highlights_for_site    
    url = params[:url]
    site = Site.first(:conditions => { :url => url })

    # Get all factlink tops for this site
    if site then @factlinks = site.factlink_tops.entries else @factlinks = [] end
        
    # Render the result with callback, so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json(:only => [:_id, :displaystring, :score]), :callback => params[:callback]
  end


  def count_for_site
    url = params[:url]
    site = Site.first(:conditions => { :url => url })
    
    count = 0
    if site
      count = site.factlink_tops.count
    end
    
    render :json => { :count => count }, :callback => params[:callback]
  end

end
