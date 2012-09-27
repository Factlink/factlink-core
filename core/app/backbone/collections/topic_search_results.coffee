class window.TopicSearchResults extends Backbone.Collection
  model: Topic

  initialize: ->
    @on 'reset', => @addNewItem()
    @searchFor ''

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  makeEmpty: ->
    @query = ''
    @reset []

  addNewItem: ->
    if @shouldShowNewItem()
      @add @getNewItem()

  shouldShowNewItem: ->
    @query != '' and not (@query.toLowerCase() in @currentLowercaseTitles())

  currentLowercaseTitles: -> _.map @pluck('title'), (item)-> item.toLowerCase()

  getNewItem: -> new Topic(
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