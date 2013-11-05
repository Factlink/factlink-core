class window.SearchResults extends Backbone.Factlink.Collection
  model: SearchResultItem

  initialize: (models, options) -> @search = options.search

  url: () -> '/search.json?s=' + @search

  query: -> @search
