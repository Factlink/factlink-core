Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @_loading = false
    @on 'request', (model) =>
      if model == @ then @_started_loading_once = @_loading = true
    @on 'sync', (model) =>
      if model == @ then @_loading = false

  loading: -> @_loading

  fetchIfUnloaded: (options) -> @_started_loading_once || @fetch options
