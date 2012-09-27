class window.TopicSearchResults extends Backbone.Collection
  model: TopicSearchResult

  initialize: ->
    @on 'reset', => @addNewItem()
    @searchFor ''

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  makeEmpty: ->
    @query = ''
    @reset []

  addNewItem: ->
    if (@shouldShowNewItem())
      @add(@getNewItem)

  shouldShowNewItem: ->
    return false if @query == ''

    current_items = _.map @pluck('title'), (item)-> item.toLowerCase()
    return @query.toLowerCase() in current_items

  getNewItem: -> new AutoCompletedChannel(
      'title':@query,
      'slug_title': @query.toLowerCase()
      'new': true)

  searchFor: (query) ->
    return if query == @query

    if query == ''
      @makeEmpty()
    else
      @query = query
      @fetch()