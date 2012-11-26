class AddChannelToChannel
  NUM_FACTS = 1

  @queue = :channel_operations

  def self.perform(subchannel_id, channel_id)
    subchannel = Channel[subchannel_id]
    channel = Channel[channel_id]

    latest_facts = subchannel.sorted_cached_facts.below('inf', count: NUM_FACTS)
    latest_facts.each do |fact|
      Resque.enqueue(AddFactToChannel, fact.id, channel.id)
    end
  end
end
