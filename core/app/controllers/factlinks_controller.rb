class FactlinksController < ApplicationController
  # GET /factlinks
  # GET /factlinks.xml
  def index
    @factlinks = Factlink.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @factlinks }
    end
  end

  # GET /factlinks/1
  # GET /factlinks/1.xml
  def show
    @factlink = Factlink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @factlink }
    end
  end

  # GET /factlinks/new
  # GET /factlinks/new.xml
  def new
    @factlink = Factlink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @factlink }
    end
  end

  # GET /factlinks/1/edit
  def edit
    @factlink = Factlink.find(params[:id])
  end

  # POST /factlinks
  # POST /factlinks.xml
  def create
    @factlink = Factlink.new(params[:factlink])

    respond_to do |format|
      if @factlink.save
        format.html { redirect_to(@factlink, :notice => 'Factlink was successfully created.') }
        format.xml  { render :xml => @factlink, :status => :created, :location => @factlink }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @factlink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /factlinks/1
  # PUT /factlinks/1.xml
  def update
    @factlink = Factlink.find(params[:id])

    respond_to do |format|
      if @factlink.update_attributes(params[:factlink])
        format.html { redirect_to(@factlink, :notice => 'Factlink was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @factlink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /factlinks/1
  # DELETE /factlinks/1.xml
  def destroy
    @factlink = Factlink.find(params[:id])
    @factlink.destroy

    respond_to do |format|
      format.html { redirect_to(factlinks_url) }
      format.xml  { head :ok }
    end
  end
end
