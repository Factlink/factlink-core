module ActivityHelper

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
    render "activities/snippets/unknown", activity: activity
  end

  def activities_for_channel_sidebar(channel)
    Activity::Query.where([
      { subject: channel },
      { object: channel },
    ]).to_a[0..10]
  end
end
