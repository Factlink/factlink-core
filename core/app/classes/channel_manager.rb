class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def editable_channels
    @channels = @gu.channels.to_a
    @username = @gu.user.username
    @channels.reject! { |channel| ! channel.editable? }
  end

  def editable_channels_for(fact)
    channels = editable_channels
    channels.map {|ch| ChannelForFact.new(ch,fact,@username)}
  end

  def containing_channel_ids(fact)
    @channels = @gu.channels.to_a
    @channels.select { |ch| ch.include? fact }.map{ |ch| ch.id }
  end
end
