class window.Fact extends Backbone.Model
  getOwnContainingChannels: (eventAggregator) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new ChannelList currentUser.channels.channelArrayForIds(containing_channel_ids),
                username: currentUser.get('username')

    eventAggregator.listenTo currentUser.channels, 'reset', ->
      col.reset currentUser.channels.channelArrayForIds(containing_channel_ids)

    col

  urlRoot: "/facts"

  removeFromChannel: (channel, opts={}) ->
    Backbone.ajax _.extend {}, opts,
      type: "post"
      url: channel.url() + "/remove/" + @get("id") + ".json"
      success: =>
        indexOf = @get("containing_channel_ids").indexOf(channel.id)
        @get("containing_channel_ids").splice indexOf, 1  if indexOf
        opts.success?()

  addToChannel: (channel, opts={}) ->
    Backbone.ajax _.extend {}, opts,
      type: "post"
      url: channel.url() + "/add/" + @get("id") + ".json"
      success: =>
        @get("containing_channel_ids").push channel.id
        opts.success?()

  getFactTally: ->
    @_fact_tally ?= new FactTally @get("tally"), fact: this

  getVotes: ->
    @_votes ?= new Votes [], fact: @

  clientLink: -> "/client/facts/#{@id}"

  user: -> new User(@get("created_by"))

  is_mine: -> @user().is_current_user()

  can_destroy: -> @is_mine() && @get('is_deletable')

  factUrlHost: ->
    fact_url = @get('fact_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  justCreated: ->
    milliseconds_ago = Date.now() - new Date(@get('created_at'))
    minutes_ago = milliseconds_ago/1000/60

    minutes_ago < 5

  share: (provider_names, message=null, options={}) ->
    Backbone.ajax _.extend {}, options,
      type: 'post'
      url: "#{@url()}/share"
      data: {provider_names, message}

  toJSON: ->
    _.extend super(),
      can_destroy: @can_destroy()
      fact_url_host: @factUrlHost()
      fact_url_title: @get('fact_title') || @factUrlHost()
      is_deletable_from_channel: @collection?.channel?.is_mine()
