class window.TopicSearchResults extends Backbone.Collection
  model: TopicSearchResult

  initialize: -> @setSearch ''

  setSearch: (query) -> @query = query

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  addNewItem: ->
    title = @query
    current_items = _.map @pluck('title'), (item)-> item.toLowerCase()

    unless @query.toLowerCase() in current_items
      model = new AutoCompletedChannel
                    'title':title,
                    'slug_title': title.toLowerCase()
                    'new': true
      @add(model)