class ChannelFacts
  attr_reader :channel
  def initialize channel
    @channel = channel
  end

  def add_fact fact
    Channel::Activities.new(channel).add_created
    channel.sorted_delete_facts.delete(fact)
    channel.sorted_internal_facts.add(fact)
    AddFactToChannelJob.perform(fact.id, channel.id, initiated_by_id: channel.created_by_id)
  end

  def remove_fact(fact)
    channel.sorted_internal_facts.delete(fact) if channel.sorted_internal_facts.include?(fact)
    channel.sorted_delete_facts.add(fact)
    Resque.enqueue(RemoveFactFromChannel, fact.id, channel.id)
    channel.activity(channel.created_by,:removed,fact,:from,channel)
  end

  def include? obj
    channel.sorted_cached_facts.include?(obj)
  end
end
