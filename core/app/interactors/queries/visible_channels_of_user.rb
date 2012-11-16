module Queries
  class VisibleChannelsOfUser
    include Pavlov::Query

    arguments :user

    def execute
      channels = real_channels_for(@user.graph_user)
      unless @user == @options[:current_user]
        channels = channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 }
      end
      channels
    end

    def real_channels_for(graph_user)
      channels = sorted_channels_for(graph_user)

      forbidden_ids = [
        graph_user.created_facts_channel_id,
        graph_user.stream_id
      ]

      channels.delete_if {|ch| forbidden_ids.include? ch.id }
    end

    def sorted_channels_for(graph_user)
      graph_user.internal_channels.
        sort_by(:lowercase_title, order: 'ALPHA ASC').to_a
    end
  end
end
