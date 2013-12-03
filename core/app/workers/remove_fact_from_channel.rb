class RemoveFactFromChannel
  @queue = :mmm_channel_operations

  def initialize(fact_id, channel_id)
    @fact ||= Fact[fact_id]
    @channel ||= Channel[channel_id]
  end
  attr_reader :fact, :channel

  def perform
    return if channel.sorted_internal_facts.include?(fact)

    fact.channels.delete(channel)
  end

  def self.perform(fact_id, channel_id)
    new(fact_id, channel_id).perform
  end
end
