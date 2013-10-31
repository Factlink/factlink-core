Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @_loading = false
    @on 'request', @_onRequest, @
    @on 'sync', @_onSync, @

  _onRequest: (collection) ->
    return unless collection == this

    @_loading = true

  _onSync: (collection) ->
    return unless collection == this

    @_loading = false

  loading: -> @_loading

  waitForFetch: (callback) ->
    if @loading()
      syncCallback = ->
        @off 'sync', syncCallback

        # run callback with "this" bound, and with first argument this collection
        callback.call(this, this)

      @on 'sync', syncCallback, @
    else
      callback.call(this, this)
