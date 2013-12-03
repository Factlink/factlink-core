class RemoveFactFromChannel
  @queue = :mmm_channel_operations

  def included_from_elsewhere?
    @included_from_elsewhere ||= channel.sorted_internal_facts.include? fact
  end

  def already_deleted?
    @already_deleted ||= not(channel.sorted_cached_facts.include?(fact))
  end

  def explicitely_deleted?
    false
  end

  def fact
    @fact ||= Fact[@fact_id]
  end

  def channel
    @channel ||= Channel[@channel_id]
  end

  def perform
    should_delete = (explicitely_deleted? or not included_from_elsewhere?)

    if should_delete
      channel.sorted_cached_facts.delete(fact) unless already_deleted?
      fact.channels.delete(channel)
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
