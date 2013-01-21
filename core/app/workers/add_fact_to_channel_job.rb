class AddFactToChannelJob
  @queue = :channel_operations

  def initialize(fact_id, channel_id, options={})
    @fact_id = fact_id
    @channel_id = channel_id
    @options = options
  end

  def perform
    return unless fact and channel
    return if already_propagated or already_deleted

    add_to_channel
    add_to_unread
    propagate_to_channels
    propagate_to_stream
  end

  def fact
    @fact ||= Fact[@fact_id]
  end

  def score
    @options['score']
  end

  def initiated_by_id
    @options['initiated_by_id']
  end

  def channel
    @channel ||= Channel[@channel_id]
  end

  def already_propagated
    channel.sorted_cached_facts.include?(fact)
  end

  def already_deleted
    channel.sorted_delete_facts.include?(fact)
  end

  def add_to_channel
    channel.sorted_cached_facts.add(fact, score)
    fact.channels.add(channel) if channel.type == 'channel'
  end

  def add_to_unread
    if (not channel.created_by_id == initiated_by_id) and
       (not channel.created_by_id == fact.created_by_id)
      channel.unread_facts.add(fact)
    end
  end

  def propagate_to_channels
    channel.containing_channels.each do |ch|
      Resque.enqueue(AddFactToChannelJob, fact.id, ch.id, @options)
    end
  end

  def propagate_to_stream
    # DEPRECATED: we should tear out the old stream
    Resque.enqueue(AddFactToChannelJob, fact.id, channel.created_by.stream.id, @options) unless channel.type == 'stream'
  end

  def self.perform(fact_id, channel_id, options={})
    new(fact_id, channel_id, options).perform
  end
end
