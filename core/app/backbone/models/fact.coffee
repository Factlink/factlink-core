class window.Fact extends Backbone.Model
  getOwnContainingChannels: (eventbinder) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new OwnChannelCollection currentUser.channels.channelArrayForIds(containing_channel_ids)

    eventbinder.bindTo currentUser.channels, 'reset', ->
      col.reset currentUser.channels.channelArrayForIds(containing_channel_ids)

    col

  urlRoot: "/facts"

  removeFromChannel: (channel, opts) ->
    opts.url = channel.url() + "/" + "remove" + "/" + @get("id") + ".json"
    oldSuccess = opts.success
    opts.success = =>
      indexOf = @get("containing_channel_ids").indexOf(channel.id)
      @get("containing_channel_ids").splice indexOf, 1  if indexOf
      if oldSuccess isnt `undefined`
        oldSuccess()

    $.ajax _.extend(type: "post", opts)

  addToChannel: (channel, opts) ->
    opts.url = channel.url() + "/" + "add" + "/" + @get("id") + ".json"
    oldSuccess = opts.success
    opts.success = =>
      @get("containing_channel_ids").push channel.id
      oldSuccess()  if oldSuccess isnt `undefined`

    $.ajax _.extend(type: "post", opts)

  getFactWheel: ->  @get("fact_base").fact_wheel

  friendlyUrl: ->
    @get("url")
