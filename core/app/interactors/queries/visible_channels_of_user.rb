module Queries
  class VisibleChannelsOfUser
    include Pavlov::Query

    arguments :user

    def execute
      channels = real_channels_for(@user.graph_user)
      if @user == @options[:current_user]
        channels
      else
        non_empty channels
      end
    end

    def real_channels_for(graph_user)
      ChannelList.new(graph_user).sorted_real_channels_as_array
    end

    def non_empty channels
      channels.select {|ch| ch.sorted_cached_facts.count > 0 }
    end
  end
end
