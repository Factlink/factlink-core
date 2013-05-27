class window.GenericChannelList extends Backbone.Factlink.Collection
  model: Channel

class window.ChannelList extends window.GenericChannelList
  _.extend @prototype, Backbone.Factlink.ActivatableCollectionMixin

  reloadingEnabled: false

  url: -> "/#{@getUsername()}/channels"

  setUsernameAndRefresh: (username)->
    @setUsername username
    @setupReloading true

  setUsernameAndRefreshIfNeeded: (username)->
    @setUsernameAndRefresh(username) if @getUsername() isnt username or @length == 0

  getUsername: -> if @_username then @_username else

  setUsername: (name) ->
    return false if @_username? and @_username is name

    @reset([])
    @_username = name
    return true

  shouldReload: ->
    getSetting("reload") isnt "false"

  setupReloading: (force_reload_now=false)->
    if @shouldReload()
      if @reloadingEnabled isnt true
        @reloadingEnabled = true
        @_startReloading()
      else if force_reload_now
        @_startReloading()

  _startReloading: ->
    args = arguments

    clearTimeout @_currentTimeout if @_currentTimeout?
    delete @_currentTimeout

    @fetch
      complete: =>
        @_currentTimeout = setTimeout _.bind(args.callee, this), (10*60*1000)-1

  getBySlugTitle: (slug_title)->
    results = @filter (ch)-> ch.get('slug_title') == slug_title
    if results.length == 1 then results[0] else `undefined`

  orderByAuthority: ->
    @comparator = (channel) ->
      -parseFloat(channel.get("created_by_authority"))
    @sort()

  orderedByAuthority: ->
    topchannels = new ChannelList(@models)
    topchannels.orderByAuthority()

    topchannels

  channelArrayForIds: (ids) ->
    array = []
    @each (ch) ->
      if ch.id in ids
        array.push ch.clone()
    array
