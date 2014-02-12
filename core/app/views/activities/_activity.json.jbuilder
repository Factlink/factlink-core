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

  when "created_comment", "created_sub_comment"
    json.target_url FactUrl.new(object).proxy_open_url
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)
    dead_fact = query(:'facts/get_dead', id: object.id.to_s)
    json.fact dead_fact
    end

  when "believes", "doubts", "disbelieves"
    dead_fact = query(:'facts/get_dead', id: subject.id.to_s)
    json.fact dead_fact

  when "followed_user"
    json.target_url user_profile_path(user.username)
    json.followed_user do
      subject_user = Queries::UsersByIds.new(user_ids: [subject.user_id]).call.first
      json.partial! 'users/user_partial', user: subject_user
    end
  end
end
