json.channels topic.top_channels(3) do |json, channel|
  json.created_by do |j|
    j.partial! 'users/user_partial', user: channel.created_by.user
  end

  json.created_by_authority sprintf('%.1f',Authority.from(topic, for: channel.created_by.graph_user).to_f+1.0)
  json.link channel_path(channel.created_by.user, channel)
  json.title channel.title
end
