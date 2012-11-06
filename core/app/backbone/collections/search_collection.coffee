class window.SearchCollection extends Backbone.Collection
  constructor: (args...)->
    super(args...)
    @searchFor ''

  makeEmpty: ->
    @query = ''
    @reset []

  searchFor: (query) ->
    return if query == @query

    if query == ''
      @makeEmpty()
    else
      @query = query
      @reset []
      @fetch()
