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
    
    case activity.object.class
      when Channel
        render "activity/snippets/channel", activity: activity
      when Fact
        render "activity/snippets/fact", activity: activity
      when FactRelation
        render "activity/snippets/fact_relation", activity: activity
    end
  end
  
end