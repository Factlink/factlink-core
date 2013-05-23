
dead_fact_wheel = query 'facts/get_dead_wheel', fact.id.to_s

def is_user_opinion(fact, type)
  return false unless user_signed_in?

  opinion_havers = fact.opiniated("#{type}s".to_sym)
  opinion_havers.include? current_graph_user
end

def opinion_type(fact, type)
  {
    percentage: fact.get_opinion.as_percentages[type][:percentage],
    is_user_opinion: is_user_opinion(fact, type)
  }
end


json.authority dead_fact_wheel.authority

json.opinion_types do |json|
  json.believe    opinion_type(fact, :believe)
  json.doubt      opinion_type(fact, :doubt)
  json.disbelieve opinion_type(fact, :disbelieve)
end
