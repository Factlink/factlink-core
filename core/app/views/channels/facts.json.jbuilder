json.array!(@facts) do |fact|
  json.partial! 'facts/fact', fact: fact[:item], timestamp: fact[:score]
end
