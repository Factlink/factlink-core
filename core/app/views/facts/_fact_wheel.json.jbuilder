def opinion_type(fact, type)
  {
    percentage: fact.get_opinion.as_percentages[type][:percentage],
    is_user_opinion: user_signed_in? && current_graph_user.has_opinion?("#{type}s".to_sym, fact)
  }
end

json.authority fact.get_opinion.as_percentages[:authority]

json.opinion_types do |json|
  json.believe    opinion_type(fact, :believe)
  json.doubt      opinion_type(fact, :doubt)
  json.disbelieve opinion_type(fact, :disbelieve)
end

# HACK: needed for InteractiveWheelView
json.fact_id fact.id
