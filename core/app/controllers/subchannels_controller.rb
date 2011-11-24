class SubchannelsController < ChannelsController
  before_filter :get_user

  before_filter :load_channel
      
  def index
    @contained_channels = @channel.contained_channels
    
    respond_to do |format|
      format.json { render :json => @contained_channels.map {|ch| Subchannels::SubchannelItem.for_channel_and_view(ch,self)} }
    end
  end
  
  private
  def is_authorized?
    @user == current_user || raise_403("Unauthorized")
  end
  
  def load_subchannel
    @subchannel = Channel[params[:subchannel_id]]
    @subchannel || raise_404("Subchannel not found")
  end
end
