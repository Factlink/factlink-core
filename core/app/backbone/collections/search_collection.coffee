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

  addNewItem: (compare_field) -> @add @getNewItem() if @shouldShowNewItem(compare_field)

  shouldShowNewItem: (compare_field) ->
    @query != '' and not (@query.toLowerCase() in @newItemFields(compare_field))

  newItemFields: (compare_field) -> _.map @pluck(compare_field), (field)-> field.toLowerCase()

  getNewItem: -> console.error "'getNewItem' was not implemented"
