class ChannelManager
  def initialize(gu)
    @gu = gu
  end

  def editable_channels(limit=nil)
    @channels = @gu.channels.to_a
    # TODO: wtf?
    @username = @gu.user.username
    @channels = @channels.reject! { |channel| ! channel.editable? }

    limit ? @channels[0..limit] : @channels
  end

  def editable_channels_by_authority(gu, limit=nil)
    auth = {}

    @channels = editable_channels

    @channels = @channels.to_a.sort do |a, b|
      topic_a = Topic.by_title(a.title)
      topic_b = Topic.by_title(b.title)

      if topic_a.new?
        topic_a.save
      end

      if topic_b.new?
        topic_b.save
      end

      auth[topic_a.id] ||= Authority.from(topic_a, for: gu).to_f
      auth[topic_b.id] ||= Authority.from(topic_b, for: gu).to_f

      auth[topic_b.id] <=> auth[topic_a.id]
    end

    limit ? @channels[0..limit] : @channels
  end

  def editable_channels_for(fact)
    channels = editable_channels
    # TODO: wtf continued; dirty shit with @username
    channels.map {|ch| ChannelForFact.new(ch,fact,@username)}
  end

  def containing_channel_ids(fact)
    @channels = @gu.channels.to_a
    @channels.select { |ch| ch.include? fact }.map{ |ch| ch.id }
  end
end
