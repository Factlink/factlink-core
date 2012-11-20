class window.Fact extends Backbone.Model
  defaults:
    fact_wheel:
      authority: "0.0"
      opinion_types: [
        type: "believe"
        groupname: "Eens"
        percentage: 33
        is_user_opinion: false
        color: "#98d100"
      ,
        type: "doubt"
        groupname: "Neutraal"
        percentage: 33
        is_user_opinion: false
        color: "#36a9e1"
      ,
        type: "disbelieve"
        groupname: "Oneens"
        percentage: 33
        is_user_opinion: false
        color: "#e94e1b"
      ]

  getOwnContainingChannels: ->
    containingChannels = @get("containing_channel_ids")
    ret = []
    currentUser.channels.each (ch) ->
      ret.push ch  if _.indexOf(containingChannels, ch.id) isnt -1

    ret

  urlRoot: "/facts/"

  removeFromChannel: (channel, opts) ->
    opts.url = channel.url() + "/" + "remove" + "/" + @get("id") + ".json"
    oldSuccess = opts.success
    opts.success = =>
      indexOf = @get("containing_channel_ids").indexOf(channel.id)
      @get("containing_channel_ids").splice indexOf, 1  if indexOf
      if oldSuccess isnt `undefined`
        console.info "hoi2"
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
