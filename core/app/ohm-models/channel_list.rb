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

  def containing_channel_ids_for_fact(fact)
    channels.to_a.select { |ch| ch.include? fact }
            .map{ |ch| ch.id }
  end

  private
  def filter_unreal channels
    forbidden_ids = [
      graph_user.created_facts_channel_id,
      graph_user.stream_id
    ]

    channels.delete_if {|ch| forbidden_ids.include? ch.id }
  end
end
