class ChannelList
  attr_reader :graph_user

  def initialize graph_user
    @graph_user = graph_user
  end

  def channels
    Channel.find(created_by_id: graph_user.id)
  end

  def sorted_channels
    channels.sort_by(:lowercase_title, order: 'ALPHA ASC')
  end

  def get_by_slug_title slug_title
    channels.find(slug_title: slug_title).first
  end

  def containing_real_channel_ids_for_fact(fact)
    (channels & fact.channels).ids
  end

  # TODO REMOVE
  def containing_channel_ids_for_channel(channel)
    (channels & channel.containing_channels).ids
  end
end
