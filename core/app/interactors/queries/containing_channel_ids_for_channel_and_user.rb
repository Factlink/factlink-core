module Queries
  # This query returns the list of channels for the
  # graph_user with graph_user_id which contain/follow
  # the channel with channel_id
  #
  # Since we cannot follow channels of ourselves in our own
  # channel we can directly return an empty list if we call
  # this for a channel of the graph_user
  class ContainingChannelIdsForChannelAndUser
    include Pavlov::Query
    arguments :channel_id, :graph_user_id

    def execute
      return [] if channel.created_by_id == @graph_user_id

      intersect_ids graph_user_channels, containing_channels
    end

    def graph_user_channels
      graph_user = GraphUser[@graph_user_id]
      Channel.active_channels_for(graph_user)
    end

    def containing_channels
      channel.containing_channels
    end

    def channel
      @channel ||= Channel[@channel_id]
    end

    def intersect_ids channels1, channels2
      (channels1 & channels2).ids
    end
  end

end
