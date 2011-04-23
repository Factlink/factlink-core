class SitesController < ApplicationController

  def highlights_for_site    
    url = params[:url]
    site = Site.first(:conditions => { :url => url })

    # Get all factlink tops for this site
    if site then @factlinks = site.factlink_tops.entries else @factlinks = [] end
        
    # Render the result with callback, so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json(:only => [:_id, :displaystring, :score]), :callback => params[:callback]
  end
  
  def show

    @factlink_top = FactlinkTop.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @factlink_top }
      format.json { render :json => @factlink_top.to_json(:methods => [:tags_array, :subs]), :callback => params[:callback] }
    end
    
    # Add the Tags array in the response
    
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
