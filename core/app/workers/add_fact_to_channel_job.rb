class AddFactToChannelJob
  @queue = :channel_operations

  attr_reader :fact, :channel

  def initialize(fact_id, channel_id, options={})
    @fact ||= Fact[fact_id]
    @channel ||= Channel[channel_id]
    @options = options
  end

  def perform
    return unless can_perform and should_perform

    add_to_channel
    add_to_unread
    propagate_to_channels
  end

  def can_perform
    fact and channel
  end

  def should_perform
    not(already_propagated or already_deleted)
  end

  def score
    @options['score']
  end

  def initiated_by_id
    @options['initiated_by_id']
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
    channel.containing_channels.ids.each do |ch_id|
      Resque.enqueue(AddFactToChannelJob, fact.id, ch_id, @options)
    end
  end

  def self.perform(fact_id, channel_id, options={})
    new(fact_id, channel_id, options).perform
  end
end
