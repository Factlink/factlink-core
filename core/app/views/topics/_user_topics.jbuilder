json.array!(user_topics) do |user_topic|
  json.partial! 'topics/user_topic', user_topic: user_topic
end
