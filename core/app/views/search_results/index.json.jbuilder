json.array!(@results) do |result|

  if result.class == FactData
    json.the_class "FactData"
    dead_fact = query(:'facts/get_dead', id: result.fact.id.to_s)
    json.the_object dead_fact
  elsif result.class == DeadUser
    json.the_class "FactlinkUser"
    json.the_object result
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
