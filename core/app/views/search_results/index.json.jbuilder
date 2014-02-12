json.array!(@results) do |result|
  if result.class == DeadFact
    json.the_class "FactData"
    json.the_object result
  elsif result.class == DeadUser
    json.the_class "FactlinkUser"
    json.the_object result
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
