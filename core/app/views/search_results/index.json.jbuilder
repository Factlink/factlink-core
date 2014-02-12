json.array!(@results) do |result|

  if result.class == FactData
    json.the_class "FactData"
    dead_fact = query(:'facts/get_dead', id: result.fact.id.to_s)
    json.the_object dead_fact
  elsif result.class == OpenStruct && result[:dead_object_name] == :user
    json.the_class "FactlinkUser"
    json.the_object {|j| j.partial! 'users/user_partial', user: result }
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
