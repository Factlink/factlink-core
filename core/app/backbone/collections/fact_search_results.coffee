#= require ./search_collection

class window.FactSearchResults extends SearchCollection
  model: Fact

  initialize: (model, options) ->
    @fact_id = options.fact_id;
    @recent_collection = options.recent_collection
    @listenTo @recent_collection, 'sync', @_search

  url: -> "/facts/#{@fact_id}/evidence_search.json?s=#{@encodedQuery()}"

  emptyState: -> @recent_collection.models

class window.FilteredFactSearchResults extends Backbone.Collection
  model: Fact
