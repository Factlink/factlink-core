Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @loading = false
    @on 'before:fetch', => @loading = true
    @on 'reset',        => @loading = false

  waitForFetch: (callback) ->
    if @loading
      resetCallback = ->
        @off 'reset', resetCallback

        # run callback with "this" bound, and with first argument this collection
        callback.call(this, this)

      @on 'reset', resetCallback, @
    else
      callback.call(this, this)
