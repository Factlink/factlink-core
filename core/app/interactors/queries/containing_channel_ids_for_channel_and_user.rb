module Queries
  class ContainingChannelIdsForChannelAndUser
    include Pavlov::Query
    arguments :channel_id, :graph_user_id

    def execute
      current_graph_user  = GraphUser[@graph_user_id]
      graph_user_channels = Channel.active_channels_for(current_graph_user)
      containing_channels = Channel[@channel_id].containing_channels

      (graph_user_channels & containing_channels).ids
    end
  end

end
