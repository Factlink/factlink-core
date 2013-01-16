class AddChannelToChannel
  NUMBER_OF_INITIAL_FACTS = 10

  @queue = :channel_operations

  def self.perform(subchannel_id, channel_id)
    subchannel = Channel[subchannel_id]
    channel = Channel[channel_id]

    latest_facts = subchannel.sorted_cached_facts.below('inf', count: NUMBER_OF_INITIAL_FACTS)
    latest_facts.each do |fact|
      Resque.enqueue(AddFactToChannelJob, fact.id, channel.id)
    end
  end
end
