class window.SearchCollection extends Backbone.Collection
  constructor: (args...)->
    super(args...)
    @searchFor ''

  emptyState: -> []

  searchFor: (query) ->
    query = $.trim(query)
    return if query == @query
    @query = query
    @_search()

  throttle = (method) -> _.throttle method, 300
  _search: throttle ->
    @jqxhr?.abort()
    if @query == ''
      @reset @emptyState()
      @trigger 'sync'
    else
      @reset []
      # reset: true because the CollectionUtils do a full reset on add/remove
      @jqxhr = @fetch(reset: true)

  encodedQuery: -> encodeURIComponent @query
