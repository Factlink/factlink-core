class window.FactSearchResults extends Backbone.Factlink.Collection
  model: Fact

  initialize: (models, options) ->
    @searchFor ''

  url: -> "/api/beta/annotations/search.json?keywords=#{@_encodedQuery()}"

  _encodedQuery: -> encodeURIComponent @query

  searchFor: (query) ->
    query = $.trim(query)
    return if query == @query
    @query = query
    @_search()

  throttle = (method) -> _.throttle method, 300
  _search: throttle ->
    @jqxhr?.abort()
    @reset []
    if @query == ''
      @trigger 'sync'
    else
      @jqxhr = @fetch()
