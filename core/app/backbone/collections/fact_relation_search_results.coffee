#= require ./search_collection

class window.FactRelationSearchResults extends SearchCollection
  model: Fact

  initialize: (model, options) ->
    @fact_id = options.fact_id;
    @recent_collection = options.recent_collection
    @listenTo @recent_collection, 'sync', @loadFromRecentCollection

  url: -> "/facts/#{@fact_id}/evidence_search.json?s=#{@encodedQuery()}"

  makeEmpty: ->
    @query = ''
    @loadFromRecentCollection()

  loadFromRecentCollection: ->
    @reset @recent_collection.models if @query == ''
    @trigger 'sync'
