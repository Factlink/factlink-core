unless user.respond_to?(:statistics) then
  fail "User partial received live user, please put in user as returned by users_by_ids"
end

json.id                            user.id.to_s
json.name                          user.name
json.username                      user.username
json.gravatar_hash                 user.gravatar_hash
json.statistics_created_fact_count user.statistics[:created_fact_count]
json.statistics_follower_count     user.statistics[:follower_count]
json.statistics_following_count    user.statistics[:following_count]

json.deleted true if user.deleted
