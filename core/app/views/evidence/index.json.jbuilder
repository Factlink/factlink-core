json.array!(@evidence) do |evidence|

  if evidence.evidence_class == 'Comment'
    json.partial! 'comments/comment', comment: evidence
  elsif evidence.evidence_class == 'FactRelation'
    bjson.partial! 'fact_relations/fact_relation', fact_relation: evidence
  else
    raise "Evidence type not supported: #{evidence.class.to_s}"
  end
end
