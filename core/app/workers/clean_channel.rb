class CleanChannel
  @queue = :channel_operations

  def self.perform(channel_id)
    channel = Channel[channel_id]
    channel.sorted_cached_facts.ids.each do |fact_id|
      if Fact.invalid(Fact[fact_id])
        channel.sorted_cached_facts.key.zrem fact_id
        channel.sorted_internal_facts.key.zrem fact_id
      end
    end
  end
end