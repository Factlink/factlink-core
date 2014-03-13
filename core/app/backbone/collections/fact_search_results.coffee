class window.FactSearchResults extends Backbone.Factlink.Collection
  model: Fact

  initialize: (models, options) ->
    @_recently_viewed_facts = options.recently_viewed_facts
    @listenTo @_recently_viewed_facts, 'sync', @_search

    @searchFor ''

  url: -> "/facts/evidence_search.json?s=#{@_encodedQuery()}"

  _encodedQuery: -> encodeURIComponent @query

  searchFor: (query) ->
    query = $.trim(query)
    return if query == @query
    @query = query
    @_search()

  throttle = (method) -> _.throttle method, 300
  _search: throttle ->
    @jqxhr?.abort()
    if @query == ''
      @reset @_recently_viewed_facts.models
      @trigger 'sync'
    else
      @reset []
      @jqxhr = @fetch()
