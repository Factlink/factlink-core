class FactlinkTopsController < ApplicationController

  before_filter :authenticate_user!, :only => [:show, :new, :edit, :create, :update]
  
  layout "client"

  ##########
  # Search using Solr
  # minimum_match is used to query using OR instead of AND
  # def search
  #   @search = FactlinkTop.search() do
  #     keywords(params[:q]) { minimum_match 1 }
  #   end
  # end


  # GET /factlink_tops
  def index
    @factlink_tops = FactlinkTop.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /factlink_tops/1
  # GET /factlink/show/1.json
  def show
    @factlink_top = FactlinkTop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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
    required_params = %W[url fact]
    error = false

    puts "\n\n#{params.to_yaml}\n\n"
    
    # Validate presence of all required parameters
    # If fail, return error message.
    required_params.each do |param|
    
      if params[param].nil?
        error = true
      end

    end
    
    # TODO: Make nice, validation for this
    if params[:fact] == '' # if params[:fact].blank? seems like a nicer solution
      error = true
    end

    # Corrupt call from Remon
    if params[:url] == 'undefined'
      error = true
    end
    
    # Return error if any parameter validation failed.
    if error
      render :json => "{\"error\": #{error}, \"message\": \"The following parameters are required: url, fact.\"}", :callback => params[:callback]
      # return is required to jump out of function
      return false      
    end
    
    
    ##########
    # Validation succesful!
    ##########
    
    # Get or create the website on which the Fact is located.
    site = Site.find_or_create_by(:url => params[:url])

    # Create the Factlink.
    @factlink_top = FactlinkTop.create!(:displaystring => params[:fact], :created_by => current_user, :site => site)
    
    # And add Factlink to the Site.
    site.factlink_tops << @factlink_top

    # Redirect to edit action
    redirect_to :action => "edit", :id => @factlink_top.id
    
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
  # def destroy
  #   @factlink_top = FactlinkTop.find(params[:id])
  #   @factlink_top.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(factlink_tops_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
