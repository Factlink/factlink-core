class FactlinkSubsController < ApplicationController

  layout "backend"

  def add_sub
    @factlink_top = FactlinkTop.find(params[:id])
    
    title = params[:title]
    content = params[:content]
    url = params[:url]

    sub = FactlinkSub.new(:title => title, :content => content, :url => url)
    sub.save

    current_user.factlink_subs << sub
    current_user.save
    
    @factlink_top.factlink_subs << sub
    @factlink_top.save
    
    render :json => { :status => true }, :callback => params[:callback]
  end
  
  def add_tag
    # TODO: Check if tag already exists
    @factlink_top = FactlinkTop.find(params[:id])
    
    tag = params[:tag]
    current_tags = @factlink_top.tags
    new_tags = current_tags << ", #{tag}"
    
    @factlink_top.tags = new_tags
    @factlink_top.save
    
    render :json => { :status => true }, :callback => params[:callback]
  end


  # Voting
  def vote_up
    @factlink_sub = FactlinkSub.find(params[:id])
    @factlink_sub.vote_up

    # Update the parent score. There is no cool callback here, so
    # do it manually.
    @factlink_sub.factlink_top.update_score
    
    # Bool for js template
    @voted_up = true

    # Render the vote template    
    render 'vote'
  end
  
  def vote_down
    @factlink_sub = FactlinkSub.find(params[:id])
    @factlink_sub.vote_down
    
    # Update the parent score. There is no cool callback here, so
    # do it manually.
    @factlink_sub.factlink_top.update_score

    # Bool for js template
    @voted_up = false
    
    # Render the vote template
    render 'vote'
  end


  # # GET /factlink_subs
  # # GET /factlink_subs.xml
  def index
    @factlink_subs = FactlinkSub.all
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @factlink_subs }
    end
  end
  
  # # GET /factlink_subs/1
  # # GET /factlink_subs/1.xml
  def show
    @factlink_sub = FactlinkSub.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @factlink_sub }
    end
  end
  # 
  # # GET /factlink_subs/new
  # # GET /factlink_subs/new.xml
  # def new
  #   @factlink_sub = FactlinkSub.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @factlink_sub }
  #   end
  # end
  # 
  # # GET /factlink_subs/1/edit
  # def edit
  #   @factlink_sub = FactlinkSub.find(params[:id])
  # end
  # 

  # # POST /factlink_subs
  # # POST /factlink_subs.xml
  def create
    @factlink_sub = FactlinkSub.new(params[:factlink_sub])
  
    respond_to do |format|
      if @factlink_sub.save
        format.html { redirect_to(@factlink_sub, :notice => 'Factlink sub was successfully created.') }
        format.xml  { render :xml => @factlink_sub, :status => :created, :location => @factlink_sub }
        format.js #{ render :json => @factlink_sub, :status => :ok }
      else
        # format.html { render :action => "new" }
        # format.xml  { render :xml => @factlink_sub.errors, :status => :unprocessable_entity }
        
        format.js     { render :add_subs_errors }
        # format.js   { render :json => @factlink_sub.errors, :status => :unprocessable_entity }
      end
    end
  end


  # # PUT /factlink_subs/1
  # # PUT /factlink_subs/1.xml
  # def update
  #   @factlink_sub = FactlinkSub.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @factlink_sub.update_attributes(params[:factlink_sub])
  #       format.html { redirect_to(@factlink_sub, :notice => 'Factlink sub was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @factlink_sub.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /factlink_subs/1
  # # DELETE /factlink_subs/1.xml
  def destroy
    @factlink_sub = FactlinkSub.find(params[:id])
    # Object for redirect
    @factlink_top = @factlink_sub.factlink_top
    # Delete it
    @factlink_sub.destroy
  
    respond_to do |format|
      format.html { redirect_to(@factlink_top, :notice => "Support is deleted.") }
      format.xml  { head :ok }
    end
  end
end
