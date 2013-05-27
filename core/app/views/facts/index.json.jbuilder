json.array!(@facts) do |fact|
  json.partial! 'facts/fact', fact: fact
end
