unless user.respond_to?(:statistics) && user.respond_to?(:top_user_topics) then
  user = Queries::UsersByIds.new(user_ids: [user.id]).call.first
end

json.id                            user.id.to_s
json.name                          user.name
json.username                      user.username
json.gravatar_hash                 user.gravatar_hash
json.statistics_created_fact_count user.statistics[:created_fact_count]

json.user_topics do
  json.partial! 'topics/user_topics', user_topics: user.top_user_topics
end
