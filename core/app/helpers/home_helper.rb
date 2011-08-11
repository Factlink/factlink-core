module HomeHelper
  
  def user_info_block(user)
    render :partial => 'home/user_profile/user_info',
              :locals => { :user => user }    
  end
  
  def user_channel_block(user)
    render :partial => "home/user_profile/channel_block", 
              :locals => { :user => user }
  end
	  
	def user_fact_block(user)
	  render :partial => "home/user_profile/fact_block", 
	            :locals => { :user => user }
	end
  
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

  def fact_snippet(fact)
    render :partial => "home/v2/snippets/fact_li", 
	            :locals => {  :fact => fact }
  end
  
  
  def fact_search
    render :partial => "home/v2/snippets/fact_search"
  end
  
  def user_block(user)
    render :partial => "home/v2/snippets/user_li",
	            :locals => {  :user => user }
  end
  
end