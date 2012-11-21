#= require ./search_collection

class window.FactRelationSearchResults extends SearchCollection
  model: Fact

  initialize: (model, options) ->
    @fact_id = options.fact_id;
    @on 'reset', => @addNewItem('displaystring')

  url: -> "/facts/#{@fact_id}/evidence_search.json?s=#{@query}"

  getNewItem: -> new FactRelationSearchResult(
    'displaystring': @query,
    'new': true
  )
