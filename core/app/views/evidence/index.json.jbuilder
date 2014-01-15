json.array!(@evidence) do |evidence|

  if evidence.evidence_class == 'Comment'
    json.partial! 'comments/comment', comment: evidence
  else
    raise "Evidence type not supported: #{evidence.class.to_s}"
  end


  # TODO: remove fact_relations/fact_relation partial
  # TODO: remove evidence_class
end
