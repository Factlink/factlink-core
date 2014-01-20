json.array!(@facts) do |fact|
  json.partial! 'facts/fact', fact: fact[:item]
  json.timestamp fact[:score]
end
