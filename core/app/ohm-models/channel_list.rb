class ChannelList
  attr_reader :graph_user

  def initialize graph_user
    @graph_user = graph_user
  end

  def channels
    Channel.find(created_by_id: graph_user.id)
  end

  def containing_real_channel_ids_for_fact(fact)
    (channels & fact.channels).ids
  end
end
