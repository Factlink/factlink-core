module HomeHelper  

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
  
end