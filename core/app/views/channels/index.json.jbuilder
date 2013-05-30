json.array!(@channels) do |channel|
  json.partial! 'channels/channel', channel: channel
end
