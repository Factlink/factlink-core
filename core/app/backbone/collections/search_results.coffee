class window.SearchResults extends Backbone.Factlink.Collection
  model: SearchResultItem
  
  initialize: (models, opts) -> @search = opts.search
  
  url: () -> '/search.json?s=' + @search

  query: -> @search
