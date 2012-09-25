class window.TopicSearchResults extends Backbone.Collection
  model: TopicSearchResult

  initialize: -> @setSearch ''

  setSearch: (query) -> @query = query

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}",