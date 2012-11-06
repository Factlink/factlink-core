class window.TopicSearchResults extends SearchCollection
  model: Topic

  initialize: ->
    @on 'reset', => @addNewItem()

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  addNewItem: -> @add @getNewItem() if @shouldShowNewItem()

  shouldShowNewItem: ->
    @query != '' and not (@query.toLowerCase() in @currentLowercaseTitles())

  currentLowercaseTitles: -> _.map @pluck('title'), (item)-> item.toLowerCase()

  getNewItem: -> new Topic(
      'title':@query,
      'slug_title': @query.toLowerCase()
      'new': true)
