class window.SearchResults extends Backbone.Factlink.Collection
  model: SearchResultItem

  initialize: (models, options) -> @search = options.search

  url: -> '/api/beta/search.json?keywords=' + @search

  query: -> @search
