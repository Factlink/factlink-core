class ChannelsController < ApplicationController

  layout "channels"
  
  before_filter :get_user

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :facts,
      :related_users,
      :activities]
  
  before_filter :authenticate_user!,
    :except => [
      :index,
      :show,
      :facts,
      :related_users
      ]
    
  before_filter :is_authorized?,
    :except => [
      :index,
      :show,
      :new,
      :create,
      :facts,
      :follow,
      :related_users,
      :activities,
    ]

  # GET /:username/channels
  def index
    @channels = @user.graph_user.channels
    
    respond_to do |format|
      format.json { render :json => @channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,self,@user)} }
      format.js
    end
  end

  # GET /:username/channels/1
  def show
    respond_to do |format|
      format.json { render :json => Channels::SingleMenuItem.for_channel_and_view(@channel,self,@user)}
      format.js
      format.html do
        @channel.mark_as_read
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
      
      unless params[:for_channel].nil?
        @subchannel = Channel[params[:for_channel]]
        @channel.add_channel(@subchannel)
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
    @channel.mark_as_read
    respond_to do |format|
      format.html { render layout: "ajax" }
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
    render layout: false, partial: "channels/related_users",
      locals: {
           related_users: @channel.related_users(:without=>[current_graph_user]).andand.map{|x| x.user },
           excluded_users: [@channel.created_by]
      }
  end
  
  def activities
    render layout:false, partial: "channels/activity_list",
      locals: {
             channel: @channel
      }
  end
  
  private
  def is_authorized?
    @user == current_user || raise_403("Unauthorized")
  end
  
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