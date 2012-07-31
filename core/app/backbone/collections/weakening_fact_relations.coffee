#= require ./fact_relations

class window.WeakeningFactRelations extends FactRelations
  url: -> @fact.url() + "/weakening_evidence"

  type: "weakening"
