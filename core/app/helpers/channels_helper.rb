module ChannelsHelper
  
  def fork_label(channel)
    if channel.created_by == current_user.graph_user
      return "duplicate"
    else
      return "add"
    end
  end
  
end
