class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def editable_channels(limit=nil)
    @channels = @gu.channels.to_a
    @channels = @channels.reject! { |channel| ! channel.editable? }

    limit ? @channels[0..limit] : @channels
  end

  def editable_channels_for(fact)
    channels = editable_channels
    @username = @gu.user.username
    channels.map {|ch| ChannelForFact.new(ch,fact,@username)}
  end

  def containing_channel_ids(fact)
    @channels = @gu.channels.to_a
    @channels.select { |ch| ch.include? fact }.map{ |ch| ch.id }
  end
end
