# This file is still being used by (at least):
#
# * users#show
# * the setting of currentUser in _currentUser.html.erb
#
#      -- mark (noted down because I thought initially it wasn't used)

user ||= @user
graph_user = user.graph_user

json.partial! 'users/user_partial', user: user

json.graph_id graph_user.id

json.location nil_if_empty user.location
json.biography nil_if_empty user.biography

json.all_channel_id graph_user.stream_id
json.created_facts_channel_id graph_user.created_facts_channel_id

is_current_user = (user == current_user)
json.is_current_user is_current_user
if is_current_user
  json.receives_mailed_notifications user.receives_mailed_notifications
end
