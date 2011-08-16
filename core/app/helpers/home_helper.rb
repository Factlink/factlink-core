module HomeHelper
  
  def channel_listing_for_user(channels, user)
    render :partial => "home/v2/snippets/channels", 
	            :locals => {  :channels => channels,
	                          :user => user }
  end
  
  def channel_snippet(channel, user)
    render :partial => "home/v2/snippets/channel_li", 
	            :locals => {  :channel => channel,
	                          :user => user }
  end

  def fact_listing(facts)
    render :partial => "home/v2/snippets/fact_listing", 
                :locals => {  :facts => facts }
  end
  
  def fact_listing_for_channel(channel)
    render :partial => "home/v2/snippets/fact_listing_for_channel", 
                :locals => {  :channel => channel }
  end

  def fact_snippet(fact, channel=nil)
    render :partial => "home/v2/snippets/fact_li", 
	            :locals => {  :fact => fact, :channel => channel }
  end
  
  def fact_search
    render :partial => "home/v2/snippets/fact_search"
  end
  
  def user_block(user)
    render :partial => "home/v2/snippets/user_li",
	            :locals => {  :user => user }
  end
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "home/v2/snippets/add_channel"
      end
    end
  end
  
  def edit_channel(user, channel)
    if user_signed_in?
      if current_user == user
        render :partial => "home/v2/snippets/edit_channel",
                :locals => {  :channel => channel,
                              :user => user }
      end
    end
  end
  
  def fact_channel_options_for_user(channel, fact)
    if user_signed_in?
      if current_user == channel.created_by.user
        render :partial => "home/v2/snippets/fact_options_for_channel",
                :locals => {  :channel => channel, :fact => fact }
      end
    end
  end

  def users_and_factlink_information
    render :partial => "home/v2/snippets/user_and_factlink_information"
  end
  
  def close_notifications_button
    render :partial => "home/v2/snippets/close_notification_button"
  end
end