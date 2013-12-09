# moving to votes
if fact_relation.class.to_s == 'FactRelation'
  # this is a live fact_relation
  votes = query(:'believable/votes', believable: fact_relation.believable)
else
  votes = fact_relation.votes
end

json.argument_votes do |j|
  j.partial! 'believable/votes', votes: votes
end

# Also move this one to interactors!
if fact_relation.class.to_s == 'FactRelation'
  can_destroy = can? :destroy, fact_relation
elsif current_user
  can_destroy = fact_relation.deletable? &&
                current_user.graph_user_id == fact_relation.created_by.id
else
  can_destroy = false
end

json.url friendly_fact_path(fact_relation.from_fact)

json.is_deletable can_destroy
json.id fact_relation.id
json.type OpinionType.for_relation_type(fact_relation.type)
json.from_fact { |j| j.partial! 'facts/fact', fact: fact_relation.from_fact }

json.time_ago TimeFormatter.as_time_ago(fact_relation.created_at.to_time)

json.created_by do |json|
  json.partial! 'users/user_partial', user: fact_relation.created_by.user
end
json.sub_comments_count fact_relation.sub_comments_count || 0
