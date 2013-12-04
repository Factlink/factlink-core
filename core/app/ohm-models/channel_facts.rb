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
    channel.activity(channel.created_by,:removed,fact,:from,channel)
  end

  def include? obj
    channel.sorted_internal_facts.include?(obj)
  end

  def facts opts={}
    return [] if channel.new?

    facts_opts = {reversed:true}
    facts_opts[:withscores] = opts[:withscores] ? true : false
    facts_opts[:count] = opts[:count].to_i if opts[:count]

    limit = opts[:from] || 'inf'

    res = channel.sorted_internal_facts.below(limit,facts_opts)

    fixchan = false

    res.reject! do |item|
      check_item = facts_opts[:withscores] ? item[:item] : item
      invalid = Fact.invalid(check_item)
      fixchan |= invalid
      invalid
    end

    if fixchan
      Resque.enqueue(CleanChannel, channel.id)
    end

    res
  end
end
