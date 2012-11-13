module Queries
  class VisibleChannelsOfUser
    include Pavlov::Query

    arguments :user

    def execute
      channels = @user.graph_user.real_channels
      unless @user == @options[:current_user]
        channels = channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 }
      end
      channels
    end

    def authorized?
      true
    end
  end
end
