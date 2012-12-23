user ||= @user
graph_user = user.graph_user

json.id user.id
json.graph_id graph_user.id

json.name user.name.blank? ? user.username : user.name
json.username user.username
json.location nil_if_empty user.location
json.biography nil_if_empty user.biography

json.gravatar_hash Gravatar.hash(user.email)
json.avatar user_avatar(user, 32)
json.avatar_thumb user_avatar(user, 20)

json.all_channel_id graph_user.stream_id
json.created_facts_channel_id graph_user.created_facts_channel_id

json.is_current_user user == current_user
json.receives_mailed_notifications user.receives_mailed_notifications