module HomeHelper
  
  def user_info_block(user)
    render :partial => 'home/user_profile/user_info',
              :locals => { :user => user }    
  end
  
  def user_channel_block(user)
    render :partial => "home/user_profile/channel_block", :locals => { :user => user }
  end
	  
	def user_fact_block(user)
	  render :partial => "home/user_profile/fact_block", :locals => { :user => user }
	end
  
end