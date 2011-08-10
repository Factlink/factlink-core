class ChannelsController < ApplicationController
  
  before_filter :get_user

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update]
  
  before_filter :authenticate_user!,
    :only => [
      :edit,
      :create,
      :destroy,
      :update
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
    
    puts "\n*\n*\n*#{params[:channel]}"
    
    @channel = Channel.new(params[:channel])

    # Check if object valid, then execute:
    if @channel.valid?
      @channel.created_by = current_user.graph_user
      @channel.save
      redirect_to(channel_path(@user.username, @channel.id), :notice => '*Channel was successfully created*')
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
      redirect_to(channel_path(@user.username, @channel.id), :notice => '*Channel was successfully updated*')
    else
      render :action => "edit"
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