Backbone.Factlink ||= {}
class Backbone.Factlink.Collection extends Backbone.Collection
  constructor: (args...) ->
    super args...
    @loading = false
    @on 'before:fetch', => @loading = true
    @on 'reset',        => @loading = false
