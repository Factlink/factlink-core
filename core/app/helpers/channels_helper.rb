module ChannelsHelper
  
  def fork_label(channel)
    if channel.created_by == current_user.graph_user
      return "make duplicate"
    else
      return "add to my channels"
    end
  end
  
end
