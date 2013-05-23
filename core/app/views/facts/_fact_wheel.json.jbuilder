dead_fact_wheel = query 'facts/get_dead_wheel', fact.id.to_s

def is_user_opinion(fact, type)
  return false unless user_signed_in?

  opinion_havers = fact.opiniated("#{type}s".to_sym)
  opinion_havers.include? current_graph_user
end

json.authority dead_fact_wheel.authority

json.opinion_types do |json|
  json.believe do
    json.percentage dead_fact_wheel.believe_percentage
    json.is_user_opinion is_user_opinion(fact, :believe)
  end
  json.doubt do
    json.percentage dead_fact_wheel.doubt_percentage
    json.is_user_opinion is_user_opinion(fact, :doubt)
  end
  json.disbelieve do
    json.percentage dead_fact_wheel.disbelieve_percentage
    json.is_user_opinion is_user_opinion(fact, :disbelieve)
  end
end
