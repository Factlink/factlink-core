class window.ChannelList extends Backbone.Factlink.Collection
  model: Channel
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  initialize: (models, options={})->
    @_username = options.username

  url: -> "/#{@_username}/channels"

  getBySlugTitle: (slug_title)->
    results = @filter (ch)-> ch.get('slug_title') == slug_title
    if results.length == 1 then results[0] else `undefined`

  channelArrayForIds: (ids) ->
    array = []
    @each (ch) ->
      if ch.id in ids
        array.push ch.clone()
    array
