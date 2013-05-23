dead_fact_wheel = query 'facts/get_dead_wheel', fact.id.to_s

json.authority dead_fact_wheel.authority

json.opinion_types do |json|
  json.believe do
    json.percentage dead_fact_wheel.believe_percentage
    json.is_user_opinion dead_fact_wheel.is_user_opinion(:believe)
  end
  json.doubt do
    json.percentage dead_fact_wheel.doubt_percentage
    json.is_user_opinion dead_fact_wheel.is_user_opinion(:doubt)
  end
  json.disbelieve do
    json.percentage dead_fact_wheel.disbelieve_percentage
    json.is_user_opinion dead_fact_wheel.is_user_opinion(:disbelieve)
  end
end
