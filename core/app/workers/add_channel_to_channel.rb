class AddChannelToChannel
  @queue = :channel_operations
  
  def self.perform(subchannel_id, channel_id)
    subchannel = Channel[subchannel_id]
    channel = Channel[channel_id]
    subchannel.sorted_cached_facts.each do |fact|
      Resque.enqueue(AddFactToChannel, fact.id, channel.id)
    end
  end
end