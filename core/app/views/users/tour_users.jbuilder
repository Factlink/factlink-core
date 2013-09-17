json.array!(@tour_users) do |user|
  json.partial! 'user_partial', user: user
  json.user_topics do
    json.array!(user.top_user_topics) do |user_topic|
      json.partial! 'topics/user_topic', user_topic: user_topic
    end
  end
end
