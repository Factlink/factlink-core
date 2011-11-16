module ActivityHelper  
  include Canivete::Deprecate

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
    render "activities/snippets/" + activity.object.class.name.underscore, activity: activity
  rescue
    "Unknown activity"
  end
  
end