class SubchannelsController < ChannelsController
  before_filter :get_user

  before_filter :load_channel
  
  before_filter :load_subchannel,
    :except => [
      :index,
    ]
      
  def index
    @contained_channels = @channel.contained_channels
    
    respond_to do |format|
      format.json { render :json => @contained_channels.map {|ch| Subchannels::SubchannelItem.for_channel_and_view(ch,self)} }
    end
  end
  
  def add
    @channel.add_channel(@subchannel)
    
    respond_to do |format|
      format.json { render :json => @channel.contained_channels.map {|ch| Subchannels::SubchannelItem.for_channel_and_view(ch,self)}, :location => @channel }
    end
  end
  
  def remove
    @channel.remove_channel(@subchannel)
    
    respond_to do |format|
      format.json { render :json => @channel.contained_channels.map {|ch| Subchannels::SubchannelItem.for_channel_and_view(ch,self)}, :location => @channel }
    end
  end
  
  private
  def load_subchannel
    @subchannel = Channel[params[:subchannel_id]]
    @subchannel || raise_404("Subchannel not found")
  end
end
