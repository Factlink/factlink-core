json.array!(@facts) do |json, fact|
  json.partial! 'facts/fact', fact: fact
end