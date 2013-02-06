class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom bottom-base'

  template: 'facts/bottom_base'

  events:
    "click .js-add-to-channel": "showAddToChannel"
    "click .js-start-conversation": "showStartConversation"
    "click .js-open-proxy-link" : "openProxyLink"

  templateHelpers: ->
    showTime: true
    showRepost: true
    showShare: true
    showSubComments: false
    showFactInfo: true
    showDiscussion: true
    fact_url_host: ->
      new Backbone.Factlink.Url(@fact_url).host() if @fact_url?

  showAddToChannel: (e) ->
    e.preventDefault()
    e.stopPropagation()

    collection = @model.getOwnContainingChannels(this)
    collection.on "add", (channel) =>
      @model.addToChannel channel, {}

    collection.on "remove", (channel) =>
      @model.removeFromChannel channel, {}
      if window.currentChannel and currentChannel.get("id") is channel.get("id")
        @model.collection.remove @model
        FactlinkApp.Modal.close()

    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(collection: collection, model: @model)

  showStartConversation: (e) ->
    e.preventDefault()
    e.stopPropagation()

    FactlinkApp.Modal.show 'Send a message',
      new StartConversationView(model: @model)

  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")

