class FactlinksController < ApplicationController

  # before_filter :authenticate_admin!
  
  layout "client"
  
  # This is NEW
  def factlinks_for_url
    url = params[:url]
    site = Site.first(:conditions => { :url => url })
    
    @factlinks = if site
                 then site.factlinks
                 else []
                 end

    # Render the result with callback, 
    # so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json( :only => [:_id, :displaystring] ), 
                                        :callback => params[:callback]  
  end

  
  def new
    @factlink = Factlink.new
  end
  
  def edit
    @factlink = Factlink.find(params[:id])
  end
  
  # Prepare for create
  def prepare
    render :template => 'factlink_tops/prepare', :layout => nil
  end
  
  # Prepare for create
  def intermediate
    # TODO: Sanitize for XSS
    @url = params[:url]
    @passage = params[:passage]
    @fact = params[:fact]
    
    case params[:the_action]
    when "prepare"
      @path = "factlink_prepare_path"
    when "show"
      @path = "factlink_show_path(%x)" % :id
    else
      @path = ""
    end

    render :template => 'factlink_tops/intermediate', :layout => nil
  end

  
  def create
    # Creating a Factlink requires a url and fact ( > displaystring )
    # TODO: Refactor 'fact' to 'displaystring' for internal consistency
    
    # Get or create the website on which the Fact is located
    site = Site.find_or_create_by(:url => params[:url])

    # Create the Factlink
    @factlink = FactlinkTop.create!(:displaystring => params[:fact], 
                                    :created_by => current_user,
                                    :site => site)

    # Redirect to edit action
    redirect_to :action => "edit", :id => @factlink.id
  end
  
  
  def update
    @factlink = Factlink.find(params[:id])

    respond_to do |format|
      if @factlink.update_attributes(params[:factlink])
        format.html { redirect_to(@factlink, :notice => 'Factlink top was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end