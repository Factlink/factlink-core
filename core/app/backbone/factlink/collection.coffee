Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @_loading = false
    @on 'before:fetch', => @_loading = true
    @on 'reset',        => @_loading = false

  loading: -> @_loading

  waitForFetch: (callback) ->
    if @_loading
      resetCallback = ->
        @off 'reset', resetCallback

        # run callback with "this" bound, and with first argument this collection
        callback.call(this, this)

      @on 'reset', resetCallback, @
    else
      callback.call(this, this)

  fetchOnce: (options={}) ->
    if @_loading
      @waitForFetch options.success if options.success?
    else
      @fetch options
