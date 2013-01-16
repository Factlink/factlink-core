class window.TopicSearchResults extends SearchCollection
  model: Topic

  initialize: (models, options) ->
    @user = options.user
    @on 'reset', => @addNewItem('title')

  comparator: (model) ->
    newItem = model.get('new')
    title = model.get('title')
    if not newItem and @user? and model.existingChannelFor @user
      "A #{title}"
    else if not newItem
      "B #{title}"
    else
      "C"

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@encodedQuery()}"

  getNewItem: -> new Topic
    'title': @query
    'slug_title': @query.toLowerCase() # not the same as what happens on the server, but good enough for now
    'new': true
