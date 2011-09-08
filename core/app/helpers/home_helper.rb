module HomeHelper
  
  def fact_listing_for_channel(channel)
    render :partial => "home/snippets/fact_listing_for_channel", 
                :locals => {  :channel => channel }
  end
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "home/snippets/add_channel"
      end
    end
  end
  
  def edit_channel(user, channel)
    if user_signed_in?
      if current_user == user
        render :partial => "home/snippets/edit_channel",
                :locals => {  :channel => channel,
                              :user => user }
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

  def users_and_factlink_information
    render :partial => "home/snippets/user_and_factlink_information"
  end
  
  def activity_list_for_user(activities, nr=19)
    render :partial => "users/partials/activity_list_for_user",
           :locals => { :activities => activities, :nr => nr }
  end

  def activity_list(activities, nr=19)
    #render :partial => "users/partials/activity_list",
    #       :locals => { :activities => activities, :nr => nr }
  end

  def close_notifications_button
    render :partial => "home/snippets/close_notification_button"
  end

  def show_activity(activity)
    render :partial => "home/snippets/show_activity",
           :locals => { :activity => activity }
  end
  
  def wide_activity_list(activities)
    render :partial => "home/snippets/wide_activity_list",
            :locals => { :activities => activities }
  end
  
  def activity_li(activity)
    render :partial => "home/snippets/activity_li",
            :locals => { :activity => activity }
  end

  def image_for_activity(activity)
        
    case activity.action
    when "added"
      return image_tag('plus.gif')
      
    when "created"
      if activity.subject.class == Fact
        return image_tag('plus.gif')
      end
      
      if activity.subject.class == Channel
        return image_tag('list_unordered.gif')
      end
    else
      return image_tag('quote.gif')
    end
  end

  def activity_for_type(activity)
    if activity.object.class == Channel
      return render :partial => "home/snippets/activity/channel",
              :locals => { :activity => activity }      
      
    end
    
    if activity.subject.class == Fact
      return render :partial => "home/snippets/activity/fact",
              :locals => { :activity => activity }      
      
    end

    if activity.subject.class == FactRelation
      return render :partial => "home/snippets/activity/fact_relation",
              :locals => { :activity => activity }
    end
  end
  
  def follow_channel(user, channel)
    if user_signed_in?
      link_to(fork_label(channel), follow_channel_path(user.username, channel.id), :class => "transparent", :remote => true)
    end
    
  end
end