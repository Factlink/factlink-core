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
      @jqxhr = @fetch()

  encodedQuery: -> encodeURIComponent @query

  addNewItem: (compare_field) ->
    return unless @shouldShowNewItem(compare_field)

    @add @getNewItem()
    @trigger 'sync'

  shouldShowNewItem: (compare_field) ->
    @query != '' and not (@query.toLowerCase() in @newItemFields(compare_field))

  newItemFields: (compare_field) -> _.map @pluck(compare_field), (field)-> field.toLowerCase()

  getNewItem: -> console.error "'getNewItem' was not implemented"
