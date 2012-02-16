class RemoveFactFromChannel
  @queue = :channel_operations

  def self.included_from_elsewhere?(fact,channel)
    channel.contained_channels.each do |subch|
      return true if subch.include? fact
    end
    return false
  end

  def self.already_deleted?(fact,channel)
    not channel.sorted_cached_facts.include?(fact)
  end

  def self.explicitely_deleted?(fact,channel)
    channel.sorted_delete_facts.include?(fact)
  end

  def self.perform(fact_id, channel_id)
    fact = Fact[fact_id]
    channel = Channel[channel_id]

    if explicitely_deleted?(fact,channel) or
       (not included_from_elsewhere?(fact,channel) and
        not already_deleted?(fact,channel))
      channel.sorted_cached_facts.delete(fact)
      fact.channels.delete(channel)
      channel.containing_channels.each do |ch|
        Resque.enqueue(RemoveFactFromChannel, fact_id, ch.id)
      end
    end
  end
end