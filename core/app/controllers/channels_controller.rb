class ChannelsController < ApplicationController

  # layout "accounting"
  layout "channels"
  
  before_filter :get_user

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update]
  
  before_filter :authenticate_user!,
    :except => [
      :index,
      :show
      ]

  # GET /:username/channel
  def index
    @channels = @user.graph_user.channels
    @channel = @channels.first
  end

  # GET /:username/channel/1
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels
  def create
    @channel = Channel.new(params[:channel])
    @channel.created_by = current_user.graph_user
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save

      unless params[:for_fact].nil?
        @fact = Fact[params[:for_fact]]
        @channel.add_fact(@fact)
      end
      
      respond_to do |format|
        format.html { redirect_to(@channel, :notice => 'Channel successfully created') }
        format.js 
      end
      
    else
      render :action => "new"
    end
  end

  # PUT /channels/1
  def update
    respond_to do |format|
      if @channel.update_attributes!(params[:channel])
        format.html  { redirect_to(@channel,
                      :notice => 'Channel was successfully updated.') }
        format.json  { render :json => {}, :status => :ok }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @channel.errors,
                      :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /channels/1
  def destroy
    if @channel.created_by == current_user.graph_user
      @channel.delete
      
      respond_to do |format|
        format.html  { redirect_to(channels_path(@user.username), :notice => 'Channel successfully deleted') }
        format.json  { render :json => {}, :status => :ok }
      end
    end
  end
  
  def remove_fact 
    @channel = Channel[params[:channel_id]]
    @fact = Fact[params[:fact_id]]

    # Quick check
    if @channel.created_by == current_user.graph_user
      @channel.remove_fact(@fact)
    end
    
  end

  def toggle_fact
    @channel  = Channel[params[:channel_id]]
    @fact     = Fact[params[:fact_id]]
    
    if @channel.facts.include?(@fact)
      @channel.remove_fact(@fact)
    else
      @channel.add_fact(@fact)
    end
    render :nothing => true    
  end
  
  def follow
    @channel = Channel[params[:channel_id]]
    @channel.fork(current_user.graph_user)
  end
  
  private
  def get_user
    if params[:username]
      @user = User.first(:conditions => { :username => params[:username]})
    end
  end
  
  def load_channel
    puts "\n\n\n\n\n\n"
    puts params[:id]
    puts "\n\n\n\n\n\n"
    @channel = Channel[params[:id]]
    unless @user
      @user = @channel.created_by.user if @channel
    end
  end
end