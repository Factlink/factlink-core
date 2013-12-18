class ChannelFacts
  attr_reader :channel
  def initialize channel
    @channel = channel
  end

  def add_fact fact
    channel.sorted_internal_facts.add(fact)
    fact.channels.add(channel)
  end

  def remove_fact(fact)
    channel.sorted_internal_facts.delete(fact)
    fact.channels.delete(channel)
  end

  def include? obj
    channel.sorted_internal_facts.include?(obj)
  end
end
