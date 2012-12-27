class AddFactToChannelJob
  @queue = :channel_operations

  def self.perform(fact_id, channel_id, options={})
    score = options['score']
    fact = Fact[fact_id]
    channel = Channel[channel_id]
    if fact and channel
      unless channel.sorted_cached_facts.include?(fact) or # this fact was already there, no propagation needed
             channel.sorted_delete_facts.include?(fact)    # this fact should not be added
        channel.sorted_cached_facts.add(fact, score)

        if (not channel.created_by_id == options['initiated_by_id']) and
           (not channel.created_by_id == fact.created_by_id)
          channel.unread_facts.add(fact)
        end

        fact.channels.add(channel) if channel.type == 'channel'
        channel.containing_channels.each do |ch|
          Resque.enqueue(AddFactToChannelJob, fact_id, ch.id, options)
        end
        # DEPRECATED: we should tear out the old stream
        Resque.enqueue(AddFactToChannelJob, fact_id, channel.created_by.stream.id, options) unless channel.type == 'stream'
      end
    end
  end
end
