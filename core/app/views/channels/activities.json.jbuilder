json.array!(@activities) do |json, activity_hash|
  activity = activity_hash[:item]
  json.timestamp activity_hash[:score]

  json.partial! 'activities/activity',
    activity: activity,
    showing_notifications: @showing_notifications

  if @showing_notifications
    json.unread activity.created_at_as_datetime > current_user.last_read_activities_on
  end
end
