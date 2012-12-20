json.array!(@evidence) do |json, evidence|

  if evidence.evidence_class == 'Comment'
    json.evidence_type 'Comment'
    json.partial! 'comments/comment', comment: evidence
  elsif evidence.evidence_class == 'FactRelation'
    json.evidence_type 'FactRelation'
    json.partial! 'fact_relations/fact_relation', fact_relation: evidence
  else
    raise "Evidence type not supported: #{evidence.class.to_s}"
  end
end
