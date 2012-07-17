json.array!(@activities) do |json, activity_hash|
  activity = activity_hash[:item]
  json.timestamp activity_hash[:score]

  user       = activity.user.user

  subject = activity.subject
  object  = activity.object
  action  = activity.action


  created_at = activity.created_at


  json.partial! 'activities/activity',
    subject: subject, object: object, action: action, created_at: created_at,
    showing_notifications: @showing_notifications, user: user

  if @showing_notifications
    json.unread activity.created_at_as_datetime > current_user.last_read_activities_on
  end
end