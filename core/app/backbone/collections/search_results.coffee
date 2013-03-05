class window.SearchResults extends Backbone.Collection
  model: SearchResultItem
  initialize: (models, opts) -> @search = opts.search
  url: () -> '/search.json?s=' + @search
