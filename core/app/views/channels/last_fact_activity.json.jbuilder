  a = @channel.added_facts.below('inf', count:1)[0]

  json.partial! 'activities/activity',
    activity: a,
    showing_notifications: false
