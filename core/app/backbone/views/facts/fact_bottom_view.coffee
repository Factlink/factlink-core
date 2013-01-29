class window.FactBottomView extends Backbone.Marionette.Layout
  className: 'fact-bottom bottom-base'

  template: 'facts/bottom_base'

  events:
    "click .js-add-to-channel": "showAddToChannel",
    "click .js-start-conversation": "showStartConversation"

  templateHelpers: ->
    showTime: true
    showRepost: true
    showShare: true
    showSubComments: false
    showFactInfo: true
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
