oldCollectionFetch = Backbone.Collection.prototype.fetch

Backbone.Collection.prototype.fetch = (options) ->
  @trigger("before:fetch")
  oldCollectionFetch.call this, options
