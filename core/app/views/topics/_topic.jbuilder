channels = topic.top_users(3).map do |user|
  channel_list = ChannelList.new(user.graph_user)
  channel = channel_list.get_by_slug_title topic.slug_title

  {
    channel: channel,
    user: user
  }
end.keep_if do |hash|
  hash[:channel]
end.map do |hash|
  {
    user_name: hash[:user].username,
    user_profile_url: user_profile_path(hash[:user]),
    channel_url: channel_path(hash[:user],hash[:channel]),
    avatar_url: hash[:user].avatar_url,
    authority: sprintf('%.1f',Authority.from(topic,for: hash[:user].graph_user).to_f+1.0)
  }
end

if channels.length > 0
  json.title topic.title
  json.channels channels
end
