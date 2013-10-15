user = channel.created_by_user
topic_authority = channel.owner_authority

# DEPRECATED, CALCULATE THIS IN FRONTEND
# e.g. `@model.get('username') == currentUser.get('username')`
is_mine = (user.id == current_user.id)

is_created = (channel.type == 'created')
is_normal = !is_created

title = if is_created
          is_mine ? 'My Factlinks' : 'Created by ' + user.name
        else
          channel.title
        end

json.type channel.type
json.is_created is_created

json.id channel.id
json.has_authority? channel.is_real_channel?

json.add_channel_url '/' + user.username + '/channels/new'

json.title title
json.slug_title channel.slug_title

json.is_normal is_normal

if topic_authority
  json.created_by_authority NumberFormatter.new(topic_authority).as_authority
end

json.created_by do |j|
  j.partial! 'users/user_partial', user: user
end


link = "/#{user.username}/channels/#{channel.id}"

json.link link
json.edit_link link + "/edit"

created_by_id = channel.created_by_id
json.created_by_id created_by_id

json.inspectable? channel.is_real_channel?
json.followable?  !is_mine && is_normal
json.editable?    is_mine && channel.is_real_channel?

# We are moving from containing_channel_ids to followed?
# consider containing_channel_ids as deprecated
containing_channel_ids = channel.containing_channel_ids
json.containing_channel_ids containing_channel_ids
json.followed? channel.containing_channel_ids.length > 0
