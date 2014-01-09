# moving to votes
if fact_relation.class.to_s == 'FactRelation'
  # this is a live fact_relation
  votes = query(:'believable/votes', believable: fact_relation.believable)
else
  votes = fact_relation.votes
end

json.tally do |j|
  j.partial! 'believable/votes', votes: votes
end

json.url friendly_fact_path(fact_relation.from_fact)

json.is_deletable fact_relation.deletable?
json.id fact_relation.id
json.type fact_relation.type
json.from_fact { |j| j.partial! 'facts/fact', fact: fact_relation.from_fact }

json.time_ago TimeFormatter.as_time_ago(fact_relation.created_at.to_time)

json.created_by do |json|
  user_id = fact_relation.created_by.user_id
  user = Queries::UsersByIds.new(user_ids: [user_id]).call.first
  json.partial! 'users/user_partial', user: user
end
json.sub_comments_count fact_relation.sub_comments_count || 0
