class ChannelManager
  def initialize(gu)
    @gu = gu
  end
  
  def editable_channel_hash_for(fact)
    @channels = @gu.channels.to_a
    @channels.reject! { |channel| ! channel.editable? }
    @channels.map {|ch| ChannelForFact.new(ch,fact)}
  end
end
