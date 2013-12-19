module Queries
  class VisibleChannelsOfUser
    include Pavlov::Query

    arguments :user

    def execute
      ChannelList.new(graph_user).sorted_channels.to_a
    end

    def graph_user
      @user.graph_user
    end
  end
end
