channels = []
topic.top_users(3).map do |user|
  channel_list = ChannelList.new(user.graph_user)
  channel = channel_list.get_by_slug_title topic.slug_title

  if channel
    channels.push({channel: channel,user: user})
  end
end

json.channels channels do |json, hash|
  user = hash[:user]

  json.created_by do |j|
    j.partial! 'users/user_partial', user: user
  end

  channel = hash[:channel]
  json.created_by_authority sprintf('%.1f',Authority.from(topic,for: user.graph_user).to_f+1.0)
  json.link channel_path(user,channel)
  json.title channel.title
end
