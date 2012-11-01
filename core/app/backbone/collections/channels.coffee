class window.GenericChannelList extends Backbone.Collection
  model: Channel

class window.TopChannelList extends window.GenericChannelList
  url: "/t/top_channels"

class window.ChannelList extends window.GenericChannelList
  model: Channel
  reloadingEnabled: false
  initialize: -> @on "reset", @checkActiveChannel

  url: ->
    "/" + @getUsername() + "/channels"

  unsetActiveChannel: ->
    activeChannel = @get(@activeChannelId)
    activeChannel.trigger "deactivate"  if activeChannel
    delete @activeChannelId

  setActiveChannel: (channel) ->
    @unsetActiveChannel()  if @activeChannelId and @activeChannelId isnt channel.id
    @activeChannelId = channel.id
    @checkActiveChannel()

  checkActiveChannel: ->
    if @activeChannelId
      activeChannel = @get(@activeChannelId)
      activeChannel.trigger "activate", activeChannel  if activeChannel

  setUsernameAndRefresh: (username)->
    @setUsername username
    @setupReloading true


  getUsername: -> if @_username then @_username else

  setUsername: (name) ->
    return false if @_username? and @_username is name

    @reset([])
    @_username = name
    return true

  shouldReload: ->
    not (typeof localStorage is "object" and localStorage isnt null and localStorage["reload"] is "false")

  setupReloading: (force_reload_now=false)->
    if @shouldReload()
      if @reloadingEnabled isnt true
        @reloadingEnabled = true
        @_startReloading()
      else if force_reload_now
        @_startReloading()


  unreadCount: ->
    @reduce ((memo, channel) ->
      memo + channel.get("unread_count")
    ), 0

  _startReloading: ->
    args = arguments

    clearTimeout @_currentTimeout if @_currentTimeout?
    delete @_currentTimeout
    callMyselfSoon = =>
      @_currentTimeout = setTimeout _.bind(args.callee, this), 7000*1000


    @fetch
      success: (collection, response) =>
        if typeof window.currentChannel isnt "undefined"
          newCurrentChannel = collection.get(currentChannel.id)
          if newCurrentChannel?
            currentChannel.set newCurrentChannel.attributes
        callMyselfSoon()

      error: callMyselfSoon()

  getBySlugTitle: (slug_title)->
    results = @filter (ch)-> ch.get('slug_title') == slug_title
    if results.length == 1 then results[0] else `undefined`

  orderedByAuthority: ->
    topchannels = new ChannelList()
    _.each @models, (channel) ->
      topchannels.add channel  if channel.get("type") is "channel"

    topchannels.comparator = (channel) ->
      -parseFloat(channel.get("created_by_authority"))

    topchannels.sort()
    topchannels
