module ChannelsHelper
  
  def add_channel(user)
    if user_signed_in? and current_user == user
        render "channels/add_channel"
    end
  end
  
end
