class RemoveChannelFromChannel
  @queue = :mmm_channel_operations

  def self.perform(subchannel_id, channel_id)
    subchannel = Channel[subchannel_id]
    channel = Channel[channel_id]
    subchannel.sorted_cached_facts.each do |fact|
     Resque.enqueue(RemoveFactFromChannel, fact.id, channel.id)
    end
  end
end
