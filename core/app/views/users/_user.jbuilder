# This file is still being used by (at least):
#
# * users#show
# * the setting of currentUser in _currentUser.html.erb
#
#      -- mark (noted down because I thought initially it wasn't used)

user ||= @user
graph_user = user.graph_user

json.id                            user.id.to_s
json.name                          user.name
json.username                      user.username
json.gravatar_hash                 user.gravatar_hash
json.deleted true if user.deleted

json.statistics_follower_count UserFollowingUsers.new(user.graph_user_id).followers_count
json.statistics_following_count UserFollowingUsers.new(user.graph_user_id).following_count

json.graph_id graph_user.id

json.location nil_if_empty user.location
json.biography nil_if_empty user.biography

if user == current_user
  json.is_current_user true
  json.receives_mailed_notifications user.receives_mailed_notifications
  json.receives_digest user.receives_digest
  json.confirmed user.confirmed?
  json.created_at user.created_at

  json.services do |json|
    if can?(:share_to, user.social_account('twitter'))
      json.twitter true
    end

    if can?(:share_to, user.social_account('facebook'))
      json.facebook true
      json.facebook_expires_at user.social_account('facebook').expires_at
    end
  end
end
