module ChannelsHelper
  
  def fork_label(channel)
    if channel.created_by == current_user.graph_user
      return "duplicate"
    else
      return "add to my channels"
    end
  end

  def follow_channel(user, channel)
    if user_signed_in?
      link_to(fork_label(channel), follow_channel_path(user.username, channel.id), :class => "transperant button", :remote => true)
    end
    
  end

end
