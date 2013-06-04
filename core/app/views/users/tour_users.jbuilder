json.array!(@tour_users) do |user|
  json.partial! 'user_partial', user: user
  json.user_topics do
    json.array!(user.top_user_topics) do |user_topic|
      json.title user_topic.title
      json.slug_title user_topic.slug_title
      json.authority user_topic.formatted_authority
    end
  end
end
