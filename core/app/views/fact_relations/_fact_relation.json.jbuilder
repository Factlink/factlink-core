current_user_opinion =
  current_user.andand.graph_user.andand.opinion_on(fact_relation)

negative_active =
  (current_user_opinion == :disbelieves) ? ' active' : ''

positive_active =
  (current_user_opinion == :believes) ? ' active' : ''

creator_authority =
  Authority.on(fact_relation, for: fact_relation.created_by).to_f + 1.0

fact_base = Facts::FactBubble.for(fact: fact_relation.from_fact, view: self)


json.url friendly_fact_path(fact_relation.from_fact)
json.signed_in? user_signed_in?
json.can_destroy? can? :destroy, fact_relation
json.weight fact_relation.percentage
json.id fact_relation.id
json.fact_relation_type fact_relation.type
json.negative_active negative_active
json.positive_active positive_active
json.fact_base fact_base.to_hash

json.created_by do |json|
  json.partial! 'users/user_partial', user: fact_relation.created_by.user
  json.authority creator_authority
end




