class AddFactToChannel
  @queue = :channel_operations

  def self.perform(fact_id, channel_id, score=nil)
    fact = Fact[fact_id]
    channel = Channel[channel_id]
    if fact and channel
      unless channel.sorted_cached_facts.include?(fact) or # this fact was already there, no propagation needed
             channel.sorted_delete_facts.include?(fact)    # this fact should not be added
        channel.sorted_cached_facts.add(fact, score)
        channel.unread_facts.add(fact)
        fact.channels.add(channel) if channel.type == 'channel'
        channel.containing_channels.each do |ch|
          Resque.enqueue(AddFactToChannel, fact_id, ch.id, score)
        end
        Resque.enqueue(AddFactToChannel, fact_id, channel.created_by.stream.id, score) unless channel.type == 'stream'
      end
    end
  end
end
