json.array!(@topics) do |json, topic|
  json.partial! 'topics/topic', topic: topic
end
