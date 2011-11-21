class ChannelManager
  def initialize(gu)
    @gu = gu
  end
  
  def editable_channels_for(fact)
    @channels = @gu.channels.to_a
    @username = @gu.user.username
    @channels.reject! { |channel| ! channel.editable? }
    @channels.map {|ch| ChannelForFact.new(ch,fact,@username)}
  end
end
