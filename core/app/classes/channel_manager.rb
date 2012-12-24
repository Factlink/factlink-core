class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def containing_channel_ids(fact)
    channels = @gu.channels.to_a
    channels.select { |ch| ch.include? fact }
            .map{ |ch| ch.id }
  end
end
