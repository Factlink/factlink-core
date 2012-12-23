class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def editable_channels_for(fact)
    channels = editable_channels
    username = @gu.user.username
    channels.map {|ch| ChannelForFact.new(ch,fact,username)}
  end

  def containing_channel_ids(fact)
    channels = @gu.channels.to_a
    channels.select { |ch| ch.include? fact }
            .map{ |ch| ch.id }
  end

  private
  def editable_channels
    ChannelList(@gu).real_channels_as_array
  end

end
