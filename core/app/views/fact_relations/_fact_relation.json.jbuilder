#todo clean up this template
#moving to current_user_opinion
if fact_relation.respond_to? :current_user_opinion
  current_user_opinion = fact_relation.current_user_opinion
elsif current_graph_user
  current_user_opinion = fact_relation.believable.opinion_of_graph_user current_graph_user
else
  current_user_opinion = nil
end

# moving to impact_opinion
if fact_relation.class.to_s == 'FactRelation'
  # this is a live fact_relation
  impact_opinion = query(:'opinions/impact_opinion_for_fact_relation',
                             fact_relation: fact_relation)
else
  impact_opinion = fact_relation.impact_opinion
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

json.can_destroy? can_destroy
json.id fact_relation.id
json.type OpinionType.for_relation_type(fact_relation.type)
json.from_fact { |j| j.partial! 'facts/fact', fact: fact_relation.from_fact }

json.current_user_opinion current_user_opinion

json.impact impact_opinion.authority

json.time_ago TimeFormatter.as_time_ago(fact_relation.created_at.to_time)

json.created_by do |json|
  json.partial! 'users/user_partial', user: fact_relation.created_by.user
end
json.sub_comments_count fact_relation.sub_comments_count || 0
