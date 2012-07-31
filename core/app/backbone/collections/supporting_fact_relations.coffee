#= require ./fact_relations

class window.SupportingFactRelations extends FactRelations
  url: -> @fact.url() + "/supporting_evidence"

  type: "supporting"
