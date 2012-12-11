class window.FactBottomView extends Backbone.Marionette.Layout
  template: "facts/fact_bottom"

  events:
    "click .js-add-to-channel": "showAddToChannel",
    "click .js-start-conversation": "showStartConversation"

  templateHelpers: ->
    fact_url_host: ->
      if @fact_url?
        url = document.createElement('a')
        url.href = @fact_url

        url.host

  onClose: -> @addToChannelView?.close()

  popupClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    popup = $(e.target).attr("class").split(" ")[0]

    @showPopup(popup)

  showAddToChannel: ->
    collection = @model.getOwnContainingChannels()
    collection.on "add", (channel) =>
      @model.addToChannel channel, {}

    collection.on "remove", (channel) =>
      @model.removeFromChannel channel, {}
      if window.currentChannel and currentChannel.get("id") is channel.get("id")
        @model.collection.remove @model
        FactlinkApp.Modal.close()

    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(collection: collection, model: @model)

  showStartConversation: ->
    FactlinkApp.Modal.show 'Send a message',
      new StartConversationView(model: @model)
