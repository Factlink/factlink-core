Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @_loading = false
    @on 'request', => @_started_loading_once = @_loading = true
    @on 'sync', => @_loading = false

  loading: -> @_loading

  fetchIfUnloaded: (options) -> @_started_loading_once || @fetch options

Marionette.View.prototype.whenModelFetched = (model, callback) ->
  if model.loading()
    @listenToOnce model, 'sync', callback
  else
    callback.call(this)
