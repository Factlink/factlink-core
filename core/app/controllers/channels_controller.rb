class ChannelsController < ApplicationController
  
  before_filter :get_user

  before_filter :load_channel, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update]
  
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
    @channel = Channel.new(params[:baron])
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save
      redirect_to(@channel, :notice => 'Baron was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /channels/1
  def update
    
    # Check if object valid, then execute:
    if @channel.valid?
      @channel.update_attributes(params[:channel])
      format.html { redirect_to(@channel, :notice => 'Baron was successfully updated.') }
      format.xml  { head :ok }
    else
      format.html { render :action => "edit" }
      format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
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
