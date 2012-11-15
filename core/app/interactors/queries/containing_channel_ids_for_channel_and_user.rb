module Queries
  class ContainingChannelIdsForChannelAndUser
    include Pavlov::Query
    arguments :channel_id, :graph_user_id

    def execute
      union_ids graph_user_channels, containing_channels
    end

    def graph_user_channels
      current_graph_user  = GraphUser[@graph_user_id]
      Channel.active_channels_for(current_graph_user)
    end

    def containing_channels
      Channel[@channel_id].containing_channels
    end

    def union_ids channels1, channels2
      (channels1 & channels2).ids
    end
  end

end
