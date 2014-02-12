subject = activity.subject
object = activity.object
action = activity.action
created_at = activity.created_at
user =  activity.user.user

dead_user = Queries::UsersByIds.new(user_ids: [user.id]).call.first
json.user {json.partial! 'users/user_partial', user: dead_user }

json.action action

json.time_ago TimeFormatter.as_time_ago(created_at.to_time)

json.id activity.id

json.activity do

  case action

  # For easier refactoring we note where each activity is used.
  # These tags come from Activity::ListenerCreator and Activity::Listener::Stream (sigh)
  # Try to keep 'em in sync

  # notifications, stream_activities
  when "created_comment", "created_sub_comment"
    json.target_url FactUrl.new(object).proxy_open_url
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      dead_fact = query(:'facts/get_dead', id: object.id.to_s)
      json.fact dead_fact
    end

  # stream_activities
  when "believes", "doubts", "disbelieves"
    dead_fact = query(:'facts/get_dead', id: subject.id.to_s)
    json.fact dead_fact

  # notifications, stream_activities
  when "followed_user"
    json.target_url user_profile_path(user.username)
    json.followed_user do
      subject_user = Queries::UsersByIds.new(user_ids: [subject.user_id]).call.first
      json.partial! 'users/user_partial', user: subject_user
    end
  end
end
