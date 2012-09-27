class window.GenericChannelList extends Backbone.Collection
  model: Channel

class window.TopChannelList extends window.GenericChannelList
  url: "/t/top_channels"

class window.ChannelList extends window.GenericChannelList
  model: Channel
  reloadingEnabled: false
  initialize: ->
    @on "activate", @setActiveChannel
    @on "reset", @checkActiveChannel

  url: ->
    "/" + @getUsername() + "/channels"

  unsetActiveChannel: ->
    activeChannel = @get(@activeChannelId)
    activeChannel.trigger "deactivate"  if activeChannel

  setActiveChannel: (channel) ->
    @unsetActiveChannel()  if @activeChannelId and @activeChannelId isnt channel.id
    @activeChannelId = channel.id

  checkActiveChannel: ->
    if @activeChannelId
      activeChannel = @get(@activeChannelId)
      activeChannel.trigger "activate", activeChannel  if activeChannel

  getUsername: -> if @_username then @_username else

  setUsername: (name) -> @_username = name

  shouldReload: ->
    not (typeof localStorage is "object" and localStorage isnt null and localStorage["reload"] is "false")

  setupReloading: ->
    if @shouldReload() and (not @reloadingEnabled is true)
      @reloadingEnabled = true
      @startReloading()

  unreadCount: ->
    @reduce ((memo, channel) ->
      memo + channel.get("unread_count")
    ), 0

  startReloading: ->
    if @shouldReload()
      args = arguments
      self = this
      setTimeout (->
        self.fetch
          success: (collection, response) ->
            if typeof window.currentChannel isnt "undefined"
              newCurrentChannel = collection.get(currentChannel.id)
              currentChannel.set newCurrentChannel.attributes
            _.bind(args.callee, self)()

          error: _.bind(args.callee, self)
      ), 7000

  getByTitle: (title)->
    results = @filter (ch)-> ch.get('title').toLowerCase() == title.toLowerCase()
    if results.length == 1 then results[0] else `undefined`

  orderedByAuthority: ->
    topchannels = new ChannelList()
    _.each @models, (channel) ->
      topchannels.add channel  if channel.get("type") is "channel"

    topchannels.comparator = (channel) ->
      -parseFloat(channel.get("created_by_authority"))

    topchannels.sort()
    topchannels
