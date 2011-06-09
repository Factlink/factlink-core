class FactlinkSubsController < ApplicationController

  layout "backend"

  before_filter :authenticate_user!, :only => [:add_tag, :vote_up, :vote_down, :create, :update]
  
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
    
    # If user DOWN voted before, restore vote.
    if @factlink_sub.down_voter_ids.include?(current_user.id)
      # User down voted self earlier, restore that vote:
      @factlink_sub.vote(:voter => current_user, :value => :down, :unvote => true)

    else
      # Else, up vote
      @factlink_sub.vote(:voter => current_user, :value => :up)
      @voted_up = true
    end

    @factlink_sub.factlink_top.update_score

    # Render the vote template    
    render 'vote'
  end
  
  def vote_down
    @factlink_sub = FactlinkSub.find(params[:id])
    
    # If user UP voted before, restore vote.
    if @factlink_sub.up_voter_ids.include?(current_user.id)
      # User up voted self earlier, restore that vote:
      @factlink_sub.vote(:voter => current_user, :value => :up, :unvote => true)

    else
      # Else, down vote
      @factlink_sub.vote(:voter => current_user, :value => :down)
      @voted_down = true
    end
    
    @factlink_sub.factlink_top.update_score
    
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

  # # GET /factlink_subs/1/edit
  # def edit
  #   @factlink_sub = FactlinkSub.find(params[:id])
  # end

  # # POST /factlink_subs
  # # POST /factlink_subs.xml
  def create
    @factlink_sub = FactlinkSub.new(params[:factlink_sub])
    @factlink_sub.created_by = current_user
  
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
  # 
  # # DELETE /factlink_subs/1
  # # DELETE /factlink_subs/1.xml
  # def destroy
  #   @factlink_sub = FactlinkSub.find(params[:id])
  #   # Object for redirect
  #   @factlink_top = @factlink_sub.factlink_top
  #   # Delete it
  #   @factlink_sub.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(@factlink_top, :notice => "Support is deleted.") }
  #     format.xml  { head :ok }
  #   end
  # end
end
