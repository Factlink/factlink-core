class window.TopicSearchResults extends SearchCollection
  model: Topic

  initialize: ->
    @on 'reset', => @addNewItem('title')

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  getNewItem: -> new Topic(
      'title':@query,
      'slug_title': @query.toLowerCase()
      'new': true)
