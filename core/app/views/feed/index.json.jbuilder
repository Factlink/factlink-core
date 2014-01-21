json.array!(@activities) do |activity_hash|
  activity = activity_hash[:item]
  json.timestamp activity_hash[:score]

  json.partial! 'activities/activity',
    activity: activity,
    showing_notifications: false

end
