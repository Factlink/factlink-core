class ChannelsController < ApplicationController

  # layout "accounting"
  layout "web-frontend-v2"
  
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
    @channels = @user.channels
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

    # Check if object valid, then execute:
    if @channel.valid?
      @channel.created_by = current_user.graph_user
      @channel.save
      redirect_to(channel_path(@user.username, @channel.id), :notice => 'Channel successfully created')
    else
      render :action => "new"
    end
  end

  # PUT /channels/1
  def update
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.update_attributes(params[:channel])
      @channel.save
      redirect_to(channel_path(@user.username, @channel.id), :notice => 'Channel successfully updated')
    else
      render :action => "edit"
    end
  end

  def add_fact    
    @channel = Channel[params[:channel_id].to_i]
    @fact = Fact[params[:fact_id]]
    
    # Quick check
    if @channel.created_by == current_user.graph_user
      @channel.add_fact(@fact)
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

  # DELETE /channels/1
  def destroy
    
  end
  
  private
  def get_user
    @user = User.first(:conditions => { :username => params[:username]})
  end
  
  def load_channel
    @channel = Channel[params[:id]]
  end
  
end