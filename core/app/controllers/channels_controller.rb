class ChannelsController < ApplicationController

  layout "channels"
  
  before_filter :get_user
  
  respond_to :json, :html

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :facts,
      :related_users,
      :activities,
      :remove_fact]
  
  before_filter :authenticate_user!
    

  # GET /:username/channels
  def index
    authorize! :index, Channel
    @channels = @user.graph_user.channels
    
    respond_to do |format|
      format.json { render :json => @channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,view_context,@user)} }
      format.js
    end
  end

  # GET /:username/channels/1
  def show
    authorize! :show, @channel
    respond_to do |format|
      format.json { render :json => Channels::SingleMenuItem.for_channel_and_view(@channel,view_context,@user)}
      format.js
      format.html do
        @channel.mark_as_read
      end
    end
  end

  # GET /:username/channels/new
  def new
    authorize! :new, Channel
    @channel = Channel.new
  end

  # GET /:username/channels/1/edit
  def edit
    authorize! :edit, @channel
  end

  # POST /:username/channels
  def create
    authorize! :update, @user
    
    @channel = Channel.new(params[:channel] || params.slice(:title))
    @channel.created_by = current_user.graph_user
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save

      unless params[:for_fact].nil?
        @fact = Fact[params[:for_fact]]
        @channel.add_fact(@fact)
      end
      
      unless params[:for_channel].nil?
        @subchannel = Channel[params[:for_channel]]
        @channel.add_channel(@subchannel)
        
        render :json => Channels::SingleMenuItem.for_channel_and_view(@channel,view_context)
        
        return
      end
      
      respond_to do |format|
        format.html { redirect_to(channel_path(@channel.created_by.user.username, @channel), :notice => 'Channel successfully created') }
        format.json { render :json => @channel,
                      :status => :created, :location => channel_path(@channel.created_by, @channel)}
        format.js
      end
      
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render :json => @channel.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  # PUT /:username/channels/1
  def update
    authorize! :update, @channel
    
    channel_params = params[:channel] || params
    
    respond_to do |format|
      if @channel.update_attributes!(channel_params.slice(:title))
        format.html  { redirect_to(channel_path(@channel.created_by.user.username, @channel),
                      :notice => 'Channel was successfully updated.' )}
        format.json  { render :json => {}, :status => :ok }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @channel.errors,
                      :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /:username/channels/1
  def destroy
    authorize! :destroy, @channel
    
    if @channel.created_by == current_user.graph_user
      @channel.delete
      
      respond_to do |format|
        format.html  { redirect_to(channel_path(@user.username, @user.graph_user.stream.id), :notice => 'Channel successfully deleted') }
        format.json  { render :json => {}, :status => :ok }
      end
    end
  end
  
  # GET /:username/channels/1/facts
  def facts
    authorize! :show, @channel

    if @channel.created_by == current_user.graph_user
      @channel.mark_as_read
    end
    
    respond_with(@channel.facts.map {|ch| Facts::FactView.for_fact_and_view(ch,view_context,@channel)})
  end
  
  def remove_fact
    authorize! :update, @channel
    @fact = Fact[params[:fact_id]]
    @channel.remove_fact(@fact)
  end

  def toggle_fact
    authorize! :update, @channel

    @channel  = Channel[params[:channel_id] || params[:id]]
    @fact     = Fact[params[:fact_id]]
    
    if @channel.facts.include?(@fact)
      @channel.remove_fact(@fact)
    else
      @channel.add_fact(@fact)
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def follow
    @channel = Channel[params[:id]]
    @channel.fork(current_user.graph_user)
  end
  
  def related_users
    authorize! :show, @channel
    
    render layout: false, partial: "channels/related_users",
      locals: {
           related_users: @channel.related_users(:without=>[current_graph_user]).andand.map{|x| x.user },
           excluded_users: [@channel.created_by]
      }
  end
  
  def activities
    authorize! :show, @channel
    render layout:false, partial: "channels/activity_list",
      locals: {
             channel: @channel
      }
  end
  
  private
  
  def get_user
    if params[:username]
      @user = User.first(:conditions => { :username => params[:username]})
    end
  end
  
  def load_channel
    @channel = Channel[params[:id]]
    @channel || raise_404("Channel not found")
    @user ||= @channel.created_by.user
  end
end