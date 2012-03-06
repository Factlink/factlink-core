class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def editable_channels(limit=nil)
    @channels = @gu.channels.to_a
    @channels = @channels.reject! { |channel| ! channel.editable? }

    limit ? @channels[0..limit] : @channels
  end

  def editable_channels_by_authority(limit=nil)
    auth = {}
    topic = {}

    @channels = editable_channels
    #return @channels

    @channels = @channels.to_a.sort do |a, b|
      topic[a.title] ||= Topic.by_title(a.title)
      topic[b.title] ||= Topic.by_title(b.title)

      topic[a.title].save if topic[a.title].new?
      topic[b.title].save if topic[b.title].new?

      auth[topic[a.title].id] ||= Authority.from(topic[a.title], for: @gu).to_f
      auth[topic[b.title].id] ||= Authority.from(topic[b.title], for: @gu).to_f

      auth[topic[b.title].id] <=> auth[topic[a.title].id]
    end

    limit ? @channels.take(limit) : @channels
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
