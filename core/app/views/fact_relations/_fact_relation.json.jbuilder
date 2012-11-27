current_user_opinion =
  current_user.andand.graph_user.andand.opinion_on(fact_relation)

negative_active =
  (current_user_opinion == :disbelieves) ? ' active' : ''

positive_active =
  (current_user_opinion == :believes) ? ' active' : ''

creator_authority =
  # HACK: This shortcut of using `fact_relation.fact` instead of `fact_relation`
  # is possible because in the current calculation these authorities are the same
  Authority.on(fact_relation.fact, for: fact_relation.created_by).to_s(1.0)

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

json.opinions OpinionPresenter.new fact_relation.get_user_opinion

json.created_by do |json|
  json.partial! 'users/user_partial', user: fact_relation.created_by.user
  json.authority creator_authority
end




