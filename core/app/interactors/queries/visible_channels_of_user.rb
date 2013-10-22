module Queries
  class VisibleChannelsOfUser
    include Pavlov::Query

    arguments :user

    def execute
      if @user == pavlov_options[:current_user]
        channels
      else
        non_empty channels
      end
    end

    def channels
      ChannelList.new(graph_user).sorted_channels.to_a
    end

    def graph_user
      @user.graph_user
    end

    def non_empty channels
      channels.select { |ch| ch.sorted_cached_facts.count > 0 }
    end
  end
end
