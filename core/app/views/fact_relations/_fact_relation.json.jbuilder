#todo clean up this template
#moving to current_user_opinion
if fact_relation.respond_to? :current_user_opinion
  current_user_opinion = fact_relation.current_user_opinion
else
  current_user_opinion = current_user.andand.graph_user.andand.opinion_on(fact_relation)
end

# moving to opinion
if fact_relation.respond_to? :get_user_opinion
  opinion = fact_relation.get_user_opinion
else
  opinion = fact_relation.opinion
end

if fact_relation.class.to_s == 'FactRelation'
  can_destroy = can? :destroy, fact_relation
else
  can_destroy = fact_relation.deletable? &&
                current_user.graph_user_id == fact_relation.created_by.id
end

creator_authority =
  # HACK: This shortcut of using `fact_relation.fact` instead of `fact_relation`
  # is possible because in the current calculation these authorities are the same
  Authority.on(fact_relation.fact, for: fact_relation.created_by).to_s(1.0)

fact_base = Facts::FactBubble.for(fact: fact_relation.from_fact, view: self)

json.url friendly_fact_path(fact_relation.from_fact)
json.signed_in? user_signed_in?

json.can_destroy? can_destroy
json.weight fact_relation.percentage
json.id fact_relation.id
json.fact_relation_type fact_relation.type
json.fact_base fact_base.to_hash

json.current_user_opinion current_user_opinion

json.opinions OpinionPresenter.new opinion

json.time_ago TimeFormatter.as_time_ago(fact_relation.created_at.to_time)

json.created_by do |json|
  json.partial! 'users/user_partial', user: fact_relation.created_by.user
  json.authority creator_authority
end
json.sub_comments_count fact_relation.sub_comments_count
