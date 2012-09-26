class window.TopicSearchResults extends Backbone.Collection
  model: TopicSearchResult

  initialize: -> @setSearch ''

  setSearch: (query) -> @query = query

  url: -> "/" + currentUser.get('username') + "/channels/find.json?s=#{@query}"

  makeEmpty: ->
    @query = ''
    @reset []

  addNewItem: ->
    title = @query
    current_items = _.map @pluck('title'), (item)-> item.toLowerCase()

    unless @query.toLowerCase() in current_items or
           @query == ''
      model = new AutoCompletedChannel
                    'title':title,
                    'slug_title': title.toLowerCase()
                    'new': true
      @add(model)