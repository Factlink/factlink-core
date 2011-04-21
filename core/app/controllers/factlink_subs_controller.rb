class FactlinkSubsController < ApplicationController
  # GET /factlink_subs
  # GET /factlink_subs.xml
  def index
    @factlink_subs = FactlinkSub.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @factlink_subs }
    end
  end

  # GET /factlink_subs/1
  # GET /factlink_subs/1.xml
  def show
    @factlink_sub = FactlinkSub.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @factlink_sub }
    end
  end

  # GET /factlink_subs/new
  # GET /factlink_subs/new.xml
  def new
    @factlink_sub = FactlinkSub.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @factlink_sub }
    end
  end

  # GET /factlink_subs/1/edit
  def edit
    @factlink_sub = FactlinkSub.find(params[:id])
  end

  # POST /factlink_subs
  # POST /factlink_subs.xml
  def create
    @factlink_sub = FactlinkSub.new(params[:factlink_sub])

    respond_to do |format|
      if @factlink_sub.save
        format.html { redirect_to(@factlink_sub, :notice => 'Factlink sub was successfully created.') }
        format.xml  { render :xml => @factlink_sub, :status => :created, :location => @factlink_sub }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @factlink_sub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /factlink_subs/1
  # PUT /factlink_subs/1.xml
  def update
    @factlink_sub = FactlinkSub.find(params[:id])

    respond_to do |format|
      if @factlink_sub.update_attributes(params[:factlink_sub])
        format.html { redirect_to(@factlink_sub, :notice => 'Factlink sub was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @factlink_sub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /factlink_subs/1
  # DELETE /factlink_subs/1.xml
  def destroy
    @factlink_sub = FactlinkSub.find(params[:id])
    @factlink_sub.destroy

    respond_to do |format|
      format.html { redirect_to(factlink_subs_url) }
      format.xml  { head :ok }
    end
  end
end
