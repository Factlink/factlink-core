json.array!(@channels) do |json, channel|
  json.partial! 'channels/channel', channel: channel
end
