class SubchannelsController < ApplicationController
  before_filter :get_user

  before_filter :load_channel
  
  before_filter :load_subchannel,
    :except => [
      :index,
    ]
      
  def index
    @contained_channels = @channel.contained_channels
    
    respond_to do |format|
      format.json { render :json => @contained_channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,view_context)} }
    end
  end
  
  def add
    authorize! :update, @channel
    @channel.add_channel(@subchannel)
    
    respond_to do |format|
      format.json { render :json => @channel.contained_channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,view_context)}, :location => @channel }
    end
  end
  
  def remove
    authorize! :update, @channel
    @channel.remove_channel(@subchannel)
    
    respond_to do |format|
      format.json { render :json => @channel.contained_channels.map {|ch| Channels::SingleMenuItem.for_channel_and_view(ch,view_context)}, :location => @channel }
    end
  end
  
  private
    def get_user
      if params[:username]
        @user = User.first(:conditions => { :username => params[:username]})
      end
    end

    def load_channel
      @channel  = Channel[params[:channel_id]||params[:id]]
      @channel || raise_404("Channel not found")
      @user ||= @channel.created_by.user
    end
  
    def load_subchannel
      @subchannel = Channel[params[:subchannel_id]]
      @subchannel || raise_404("Subchannel not found")
    end
end
