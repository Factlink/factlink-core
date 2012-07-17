  user       = @channel.created_by.user

  fact = @channel.facts(count: 1, withscores:true)[0]
  subject = fact[:item]
  object  = @channel
  action  = 'added_fact_to_channel'

  json.timestamp fact[:score]

  created_at = Time.at(fact[:score])

  json.partial! 'activities/activity',
    subject: subject, object: object, action: action, created_at: created_at,
    showing_notifications: false , user: user