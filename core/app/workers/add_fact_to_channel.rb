class AddFactToChannel
  @queue = :channel_operations
  
  def self.perform(fact_id, channel_id)
    fact = Fact[fact_id]
    channel = Channel[channel_id]
    unless channel.sorted_cached_facts.include?(fact) or # this fact was already there, no propagation needed
           channel.sorted_delete_facts.include?(fact)    # this fact should not be added
      channel.sorted_cached_facts.add(fact)
      channel.containing_channels.each do |ch|
        Resque.enqueue(AddFactToChannel, fact_id, ch.id)
      end
    end
  end
end