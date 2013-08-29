#= require ./search_collection

class window.FactRelationSearchResults extends SearchCollection
  model: Fact

  initialize: (model, options) ->
    @fact_id = options.fact_id;
    @recent_collection = options.recent_collection
    @listenTo @recent_collection, 'sync', @_search

  url: -> "/facts/#{@fact_id}/evidence_search.json?s=#{@encodedQuery()}"

  emptyState: -> @recent_collection.models

class window.FilteredFactRelationSearchResults extends Backbone.Collection
  model: Fact
