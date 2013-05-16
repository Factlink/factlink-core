json.array!(@results) do |json, result|

  if result.class == FactData
    json.the_class "FactData"
    json.the_object {|j| j.partial! 'facts/fact', fact: result.fact }
  elsif result.class == FactlinkUser
    json.the_class "FactlinkUser"
    json.the_object {|j| j.partial! 'users/user_partial', user: result }
  elsif result.class == OpenStruct && result.dead_object_name == :topic
    json.the_class "Topic"
    json.the_object do |j|
      j.partial! 'topics/topic', topic: result
      j.current_user_authority result.current_user_authority
      j.facts_count result.facts_count
    end
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
