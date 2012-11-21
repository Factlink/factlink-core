#= require ./search_collection

class window.FactRelationSearchResults extends SearchCollection
  model: Fact

  initialize: (model, options) ->
    @fact_id = options.fact_id;

  url: -> "/facts/#{@fact_id}/evidence_search.json?s=#{@query}"
