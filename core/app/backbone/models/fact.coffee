class window.Fact extends Backbone.Model
  getOwnContainingChannels: (eventbinder) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new OwnChannelCollection currentUser.channels.channelArrayForIds(containing_channel_ids)

    eventbinder.bindTo currentUser.channels, 'reset', ->
      col.reset currentUser.channels.channelArrayForIds(containing_channel_ids)

    col

  urlRoot: "/facts"

  opinionPercentage: (type)->
    @get('fact_wheel').opinion_types[type].percentage

  removeFromChannel: (channel, opts={}) ->
    opts.url = channel.url() + "/" + "remove" + "/" + @get("id") + ".json"
    oldSuccess = opts.success
    opts.success = =>
      indexOf = @get("containing_channel_ids").indexOf(channel.id)
      @get("containing_channel_ids").splice indexOf, 1  if indexOf
      if oldSuccess isnt `undefined`
        oldSuccess()

    $.ajax _.extend(type: "post", opts)

  addToChannel: (channel, opts={}) ->
    opts.url = channel.url() + "/" + "add" + "/" + @get("id") + ".json"
    oldSuccess = opts.success
    opts.success = =>
      @get("containing_channel_ids").push channel.id
      oldSuccess()  if oldSuccess isnt `undefined`

    $.ajax _.extend(type: "post", opts)

  getFactWheel: ->  @get("fact_wheel")

  friendlyUrl: ->
    @get("url")

  user: -> new User(@get("created_by"))

  # TODO: rename to is_mine
  i_am_owner: -> @user().is_current_user()

  factUrlHost: ->
    fact_url = @get('fact_url')
    return '' unless fact_url

    new Backbone.Factlink.Url(fact_url).host()

  toJSON: ->
    _.extend super(),
      i_am_owner: @i_am_owner()
      fact_url_host: @factUrlHost()
      fact_url_title: @get('fact_title') || @factUrlHost()
