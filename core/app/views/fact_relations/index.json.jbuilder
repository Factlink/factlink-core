json.array!(@fact_relations) do |fr|
  json.partial! 'fact_relations/fact_relation', fact_relation: fr
end
