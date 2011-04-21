class FactlinkTopsController < ApplicationController
  
  layout "clean"

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
  def create
    @factlink_top = FactlinkTop.new(params[:factlink_top])

    site = Site.find(params[:site_id])
    @factlink_top.sites << site

    respond_to do |format|
      if @factlink_top.save
        format.html { redirect_to(@factlink_top, :notice => 'Factlink top was successfully created.') }
        format.xml  { render :xml => @factlink_top, :status => :created, :location => @factlink_top }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @factlink_top.errors, :status => :unprocessable_entity }
      end
    end
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
