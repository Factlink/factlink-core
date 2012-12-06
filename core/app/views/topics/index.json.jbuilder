json.array!(@topics) do |json, topic|
  json.title      topic.title
  json.slug_title topic.slug_title
end
