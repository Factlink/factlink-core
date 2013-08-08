Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @_loading = false
    @on 'request', => @_loading = true
    @on 'sync',   => @_loading = false

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

  fetchOnce: (options={}) ->
    if @loading()
      @waitForFetch options.success if options.success?
    else
      @fetch options
