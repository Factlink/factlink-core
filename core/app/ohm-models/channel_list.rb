class ChannelList
  attr_reader :graph_user

  def initialize graph_user
    @graph_user = graph_user
  end

  def channels
    Channel.find(created_by_id: graph_user.id)
  end

  def sorted_channels
    channels.sort_by(:slug_title, order: 'ALPHA ASC')
  end
end
