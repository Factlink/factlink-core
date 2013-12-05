class window.Fact extends Backbone.Model
  getOwnContainingChannels: (eventAggregator) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new OwnChannelCollection currentUser.channels.channelArrayForIds(containing_channel_ids)

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

  getFactWheel: ->
    unless @_fact_wheel?
      @_fact_wheel = new Wheel _.extend {}, @get("fact_votes"), fact_id: @id
      @on 'change:id', -> @_fact_wheel.set 'fact_id', @id
    @_fact_wheel

  clientLink: -> "/client/facts/#{@id}"

  user: -> new User(@get("created_by"))

  is_mine: -> @user().is_current_user()

  can_destroy: -> @is_mine() && @get('is_deletable')

  factUrlHost: ->
    fact_url = @get('fact_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  share: (provider_name, options={}) ->
    fact_sharing_options = {}
    fact_sharing_options[provider_name] = true

    Backbone.ajax _.extend {}, options,
      type: 'post'
      url: "#{@url()}/share"
      data: {fact_sharing_options}

  toJSON: ->
    _.extend super(),
      can_destroy: @can_destroy()
      fact_url_host: @factUrlHost()
      fact_url_title: @get('fact_title') || @factUrlHost()
      is_deletable_from_channel: @collection?.channel?.is_mine()
