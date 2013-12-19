class window.GenericChannelList extends Backbone.Factlink.Collection
  model: Channel

class window.ChannelList extends window.GenericChannelList
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  url: -> "/#{@getUsername()}/channels"

  getUsername: -> @_username
  setUsername: (username) -> @_username = username

  getBySlugTitle: (slug_title)->
    results = @filter (ch)-> ch.get('slug_title') == slug_title
    if results.length == 1 then results[0] else `undefined`

  channelArrayForIds: (ids) ->
    array = []
    @each (ch) ->
      if ch.id in ids
        array.push ch.clone()
    array
