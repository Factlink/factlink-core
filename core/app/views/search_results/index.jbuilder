json.array!(@results) do |json, result|

  if result.class == FactData
    json.the_class "FactData"
    json.the_object do |json|
      json.partial! 'facts/fact', fact: result.fact
    end
  elsif result.class == FactlinkUser
    json.the_class "FactlinkUser"
    json.the_object do |json|
      json.partial! 'users/user_partial', user: result
    end
  elsif result.class == Topic
    json.the_class "Topic"
    json.the_object do |json|
      json.partial! 'topics/topic', topic: result
    end
  else
    raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
  end
end
