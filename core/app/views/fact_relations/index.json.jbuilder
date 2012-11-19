json.array!(@fact_relations) do |json, fr|
  json.partial! 'fact_relations/fact_relation', fact_relation: fr
end
