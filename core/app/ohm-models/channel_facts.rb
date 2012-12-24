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
end
