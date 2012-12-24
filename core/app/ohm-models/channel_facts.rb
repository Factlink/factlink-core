class ChannelFacts
  attr_reader :channel
  def initialize channel
    @channel = channel
  end

  def add_fact fact
    channel.add_created_channel_activity
    channel.sorted_delete_facts.delete(fact)
    channel.sorted_internal_facts.add(fact)
    Resque.enqueue(AddFactToChannelJob, fact.id, channel.id, initiated_by_id: channel.created_by_id)
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

  def facts opts={}
    return [] if channel.new?

    facts_opts = {reversed:true}
    facts_opts[:withscores] = opts[:withscores] ? true : false
    facts_opts[:count] = opts[:count].to_i if opts[:count]

    limit = opts[:from] || 'inf'

    res = channel.sorted_cached_facts.below(limit,facts_opts)

    fixchan = false

    res.delete_if do |item|
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

  def unread_count
    channel.unread_facts.size
  end

  def mark_as_read
    channel.unread_facts.make_empty
  end
end
