json.array!(@results) do |json, result|

  if result.class == FactData
    json.the_class "FactData"
    json.the_object {|j| j.partial! 'facts/fact', fact: result.fact }
  elsif result.class == FactlinkUser
    json.the_class "FactlinkUser"
    json.the_object {|j| j.partial! 'users/user_partial', user: result }
  elsif result.class == Topic
    json.the_class "Topic"
    json.the_object do |json|
      json.partial! 'topics/topic', topic: result
      json.current_user_authority "1.3"
      json.facts_count 1337
    end
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
