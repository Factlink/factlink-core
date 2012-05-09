class ChannelEnsureInternalInCached
  @queue = :channel_operations
  
  def self.perform(channel_id)
    channel = Channel[channel_id]
    channel.sorted_internal_facts.below('inf',withscores:true).each do |h|
      channel.sorted_cached_facts.add h[:item], h[:score]
    end
  end
end