class FactlinkTopsController < ApplicationController
  
  layout "client"

  ##########
  # Search using Solr
  # minimum_match is used to query using OR instead of AND
  def search
    @search = FactlinkTop.search() do
      keywords(params[:q]) { minimum_match 1 }
    end
  end


  # GET /factlink_tops
  # GET /factlink_tops.xml
  def index
    @factlink_tops = FactlinkTop.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @factlink_tops }
    end
  end

  # GET /factlink_tops/1
  # GET /factlink_tops/1.xml
  def show
    @factlink_top = FactlinkTop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @factlink_top }
      format.json { render :json => @factlink_top.to_json(:methods => [:tags_array, :subs]), :callback => params[:callback] }
    end
  end

  # GET /factlink_tops/new
  # GET /factlink_tops/new.xml
  def new
    @factlink_top = FactlinkTop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @factlink_top }
    end
  end

  # GET /factlink_tops/1/edit
  def edit
    @factlink_top = FactlinkTop.find(params[:id])
  end

  # POST /factlink_tops
  # POST /factlink_tops.xml
  # def create
  #   @factlink_top = FactlinkTop.new(params[:factlink_top])
  # 
  #   site = Site.find(params[:site_id])
  #   @factlink_top.sites << site
  # 
  #   respond_to do |format|
  #     if @factlink_top.save
  #       format.html { redirect_to(@factlink_top, :notice => 'Factlink top was successfully created.') }
  #       format.xml  { render :xml => @factlink_top, :status => :created, :location => @factlink_top }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @factlink_top.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  
  
  def create
    required_params = %W[url fact callback]
    error = false
    
    # Validate presence of all required parameters
    # If fail, return error message.
    required_params.each do |param|
      if params[param].nil?
        error = true
        render :json => "{\"error\": #{error}, \"message\": \"The following parameters are required: url, fact, callback.\"}", :callback => params[:callback]
        # return is required to jump out of function
        return false
      end
    end
    
    # Get or create the website on which the Fact is located.
    site = Site.find_or_create_by(:url => params[:url])

    # Create the Factlink.
    new_factlink = FactlinkTop.create!(:displaystring => params[:fact])
    
    # And add Factlink to the Site.
    site.factlink_tops << new_factlink
    
    added = true
    status = true
    match_id = new_factlink.id
    
    # Create the result payload
    res_dict = {}
    res_dict[:added] = added
    res_dict[:status] = status
    res_dict[:match_id] = match_id
    
    render :json => res_dict, :callback => params[:callback]
    
  end

  # PUT /factlink_tops/1
  # PUT /factlink_tops/1.xml
  def update
    @factlink_top = FactlinkTop.find(params[:id])

    respond_to do |format|
      if @factlink_top.update_attributes(params[:factlink_top])
        format.html { redirect_to(@factlink_top, :notice => 'Factlink top was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @factlink_top.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /factlink_tops/1
  # DELETE /factlink_tops/1.xml
  def destroy
    @factlink_top = FactlinkTop.find(params[:id])
    @factlink_top.destroy

    respond_to do |format|
      format.html { redirect_to(factlink_tops_url) }
      format.xml  { head :ok }
    end
  end
end
