json.array!(@results) do |json, result|

  if result.class == FactData
    json.the_class "FactData"
    json.the_object {|j| j.partial! 'facts/fact', fact: result.fact }
  elsif result.class == FactlinkUser
    json.the_class "FactlinkUser"
    json.the_object {|j| j.partial! 'users/user_partial', user: result }
  elsif result.class == Topic
    json.the_class "Topic"
    json.the_object {|j| j.partial! 'search_results/topic', topic: result }
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
