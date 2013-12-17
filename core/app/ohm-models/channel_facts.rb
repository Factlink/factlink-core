class ChannelFacts
  attr_reader :channel
  def initialize channel
    @channel = channel
  end

  def add_fact fact
    channel.sorted_internal_facts.add(fact)
  end

  def remove_fact(fact)
    channel.sorted_internal_facts.delete(fact) if channel.sorted_internal_facts.include?(fact)
    Resque.enqueue(RemoveFactFromChannel, fact.id, channel.id)
  end

  def include? obj
    channel.sorted_internal_facts.include?(obj)
  end
end
