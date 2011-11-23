class SubchannelsController < ChannelsController
  before_filter :get_user

  before_filter :load_channel
      
  def index
    @contained_channels = @channel.contained_channels
    
    respond_to do |format|
      format.json { render :json => @contained_channels.map {|ch| Channels::SubchannelItem.for_channel_and_view(ch,self)} }
    end
  end
  
  private
  def load_channel
    @channel = Channel[params[:channel_id]]
    @channel || raise_404("Channel not found")
    @user ||= @channel.created_by.user
  end
end
