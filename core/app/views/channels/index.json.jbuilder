json.array!(@channels) do |channel|
  json.id channel.id
  json.title channel.title
  json.slug_title channel.slug_title
end
