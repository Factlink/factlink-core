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

      channel_list.containing_channel_ids_for_channel channel
    end

    def channel_list
      ChannelList.new(graph_user)
    end

    def graph_user
      GraphUser[@graph_user_id]
    end

    def channel
      @channel ||= Channel[@channel_id]
    end
  end

end
