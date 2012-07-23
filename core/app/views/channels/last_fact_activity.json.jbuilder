  a = @channel.added_facts.below('inf', count:1)[0]

  json.partial! 'activities/activity',
    subject: a.subject, object: a.object, action: a.action,
    created_at: a.created_at,
    showing_notifications: false , user: a.user.user