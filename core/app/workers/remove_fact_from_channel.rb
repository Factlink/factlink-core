class RemoveFactFromChannel
  @queue = :channel_operations

  def included_from_elsewhere_internal?
    return true if channel.sorted_internal_facts.include? fact
    channel.contained_channels.each do |subch|
      return true if subch.include? fact
    end
    return false
  end
  def included_from_elsewhere?
    @included_from_elsewhere ||= included_from_elsewhere_internal?
  end

  def already_deleted?
    @already_deleted ||= not(channel.sorted_cached_facts.include?(fact))
  end

  def explicitely_deleted?
    @explicitely_deleted ||= channel.sorted_delete_facts.include?(fact)
  end

  def fact
    @fact ||= Fact[@fact_id]
  end

  def channel
    @channel ||= Channel[@channel_id]
  end

  def perform
    should_delete = (explicitely_deleted? or not included_from_elsewhere?)
    should_propagate = (not already_deleted?)

    if should_delete
      channel.sorted_cached_facts.delete(fact) unless already_deleted?
      fact.channels.delete(channel)
      if should_propagate
        channel.containing_channels.each do |ch|
          Resque.enqueue(RemoveFactFromChannel, fact.id, ch.id)
        end
      end
    end
  end

  def initialize(fact_id, channel_id)
    @fact_id = fact_id
    @channel_id = channel_id
  end

  def self.perform(fact_id, channel_id)
    new(fact_id, channel_id).perform
  end

end
