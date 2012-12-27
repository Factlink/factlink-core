user = channel.created_by_user
topic_authority = channel.owner_authority

is_mine = (user.id == current_user.id) #DEPRECATED, CALCULATE THIS IN FRONTEND SEE related_users_view.coffee
is_created = (channel.type == 'created')
is_all = (channel.type == 'stream')
is_normal = !is_all && !is_created
is_discover_stream = is_all && is_mine


title = if is_all
          'Stream'
        elsif is_created
          is_mine ? 'My Factlinks' : 'Created by ' + user.username
        else
          channel.title
        end

long_title = if is_all
               is_mine ? 'Stream' : "Stream of #{user.username}"
             else
               title
             end

json.type channel.type
json.is_created is_created
json.is_all is_all

json.is_mine is_mine
json.id channel.id
json.has_authority? channel.is_real_channel?

json.add_channel_url '/' + user.username + '/channels/new'

json.title title
json.long_title long_title
json.slug_title channel.slug_title

json.is_normal is_normal


if topic_authority
  json.created_by_authority NumberFormatter.new(topic_authority).as_authority
end

json.created_by do |j|
  j.id user.id
  j.username user.username
  j.avatar image_tag(user.avatar_url_32, title: user.username, alt: user.username, width: 32)
  j.all_channel_id user.stream_id
end

json.discover_stream? is_discover_stream

link = if is_discover_stream
        "/#{user.username}/channels/#{channel.id}/activities"
       else
        "/#{user.username}/channels/#{channel.id}"
       end
json.link link
json.edit_link link + "/edit"

created_by_id = channel.created_by_id
json.created_by_id created_by_id

json.inspectable? channel.is_real_channel?
json.followable?  !is_mine && is_normal
json.editable?    is_mine && channel.is_real_channel?

# QUICK FIX only show unread count on own channel
if is_mine then
  unread_count = is_normal ? channel.unread_count : 0

  json.unread_count unread_count
  json.new_facts unread_count != 0
end

json.containing_channel_ids channel.containing_channel_ids
