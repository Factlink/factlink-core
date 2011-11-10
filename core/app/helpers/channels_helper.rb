require 'active_support/configurable'

module ChannelsHelper
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "channels/add_channel"
      end
    end
  end
  
end
