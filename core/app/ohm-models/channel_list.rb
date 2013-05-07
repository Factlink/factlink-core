class ChannelList
  attr_reader :graph_user

  def initialize graph_user
    @graph_user = graph_user
  end

  def channels
    Channel.find(:created_by_id => graph_user.id)
  end

  def real_channels_as_array
    filter_unreal channels.to_a
  end

  def sorted_channels
    channels.sort_by(:lowercase_title, order: 'ALPHA ASC')
  end

  def sorted_real_channels_as_array
    filter_unreal(sorted_channels.to_a)
  end

  def get_by_slug_title slug_title
    channels.find(slug_title: slug_title).first
  end
  
  def containing_real_channel_ids_for_fact(fact)
    # Might not be necessary to filter unreal ids here
    # We do it anyway because we were not sure if this would
    # be necessary or not, as part of a quick hack! (defensive coding ;))
    filter_unreal_ids((channels & fact.channels).ids)
  end

  def containing_channel_ids_for_channel(channel)
    (channels & channel.containing_channels).ids
  end

  private
  def filter_unreal channels
    channels.reject {|ch| forbidden_ids.include? ch.id }
  end

  def filter_unreal_ids ids
    ids.reject {|id| forbidden_ids.include? id }
  end

  def forbidden_ids
    [
      graph_user.created_facts_channel_id,
      graph_user.stream_id
    ]
  end
end
