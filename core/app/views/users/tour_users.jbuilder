json.array!(@tour_users) do |user|
  json.partial! 'user_partial', user: user
  json.user_topics do
    json.partial! 'topics/user_topics', user_topics: user.top_user_topics
  end
end
