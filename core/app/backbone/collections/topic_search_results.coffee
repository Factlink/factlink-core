class window.TopicSearchResults extends SearchCollection
  model: Topic

  initialize: (models, options) ->
    @user = options.user
    @on 'sync', => @addNewItem('title')

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@encodedQuery()}"

  getNewItem: -> new Topic
    'title': @query
    'slug_title': @query.toLowerCase() # not the same as what happens on the server, but good enough for now
    'new': true

class window.FilteredTopicSearchResults extends Backbone.Collection
  model: Topic
