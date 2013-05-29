json.array!(@tour_users) do |user|
  json.partial! 'user_partial', user: user
  json.user_topics do
    json.array!(user.top_user_topics) do |user_topic|
      json.(user_topic, :title, :slug_title, :authority)
    end
  end
end
