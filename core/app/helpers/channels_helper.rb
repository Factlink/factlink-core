module ChannelsHelper
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "home/snippets/add_channel"
      end
    end
  end
  
  def fact_channel_options_for_user(channel, fact)
    if user_signed_in?
      if current_user == channel.created_by.user
        render :partial => "home/snippets/fact_options_for_channel",
                :locals => {  :channel => channel, :fact => fact }
      end
    end
  end

end
