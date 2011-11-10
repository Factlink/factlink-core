class ChannelsController < ApplicationController

  # layout "accounting"
  layout "channels"
  
  before_filter :get_user

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :facts,
      :related_users]
  
  before_filter :authenticate_user!,
    :except => [
      :index,
      :show,
      :facts,
      :related_users
      ]

  # GET /:username/channels
  def index
    @channels = @user.graph_user.channels
    
    respond_to do |format|
      format.html
      format.json { render :json => @channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,self)} }
      format.js
    end
  end

  # GET /:username/channels/1
  def show
    respond_to do |format|
      format.json { render :json => Channels::SingleMenuItem.for_channel_and_view(@channel,self)}
      format.js
      format.html do
        @channel.mark_as_read
        render :action => "facts" 
      end
    end
  end

  # GET /:username/channels/new
  def new
    @channel = Channel.new
  end

  # GET /:username/channels/1/edit
  def edit
  end

  # POST /:username/channels
  def create
    @channel = Channel.new(params[:channel] || params.slice(:title))
    @channel.created_by = current_user.graph_user
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save

      unless params[:for_fact].nil?
        @fact = Fact[params[:for_fact]]
        @channel.add_fact(@fact)
      end
      
      respond_to do |format|
        format.html { redirect_to(get_facts_for_channel_path(@channel.created_by.user.username, @channel), :notice => 'Channel successfully created') }
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
    channel_params = params[:channel] || params
    
    respond_to do |format|
      if @channel.update_attributes!(channel_params.slice(:title, :description))
        format.html  { redirect_to(get_facts_for_channel_path(@channel.created_by.user.username, @channel),
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
    if @channel.created_by == current_user.graph_user
      @channel.delete
      
      respond_to do |format|
        format.html  { redirect_to(get_facts_for_channel_path(@user.username, @user.graph_user.stream.id), :notice => 'Channel successfully deleted') }
        format.json  { render :json => {}, :status => :ok }
      end
    end
  end
  
  # GET /:username/channels/1/facts
  def facts
    @channel.mark_as_read
    respond_to do |format|
      if request.xhr?
        format.html { render :layout => "ajax" }
      else
        format.html
      end
    end
  end
  
  def remove_fact 
    @channel = Channel[params[:id]]
    @fact = Fact[params[:fact_id]]

    # Quick check
    if @channel.created_by == current_user.graph_user
      @channel.remove_fact(@fact)
    end
  end

  def toggle_fact
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
    # @channel is fetched in load_channel    
    @partial = "channels/related_users"
    
    
    @locals = { :related_users => @channel.related_users(:without=>[current_graph_user]).andand.map{|x| x.user }, :excluded_users => [@channel.created_by]}
    respond_to do |format|
      format.html { render :template => "home/partial_renderer", :layout => "ajax" }
    end
  end
  
  private
  def get_user
    if params[:username]
      @user = User.first(:conditions => { :username => params[:username]})
    end
  end
  
  
  def load_channel
    if params[:id] == "all"
      @channel = @user.graph_user.stream
    else
      @channel = Channel[params[:id]]
    end
    
    @channel || raise(ActionController::RoutingError.new("Channel not found"))
    
    unless @user
      @user = @channel.created_by.user if @channel
    end
  end
end