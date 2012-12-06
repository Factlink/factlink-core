class window.FactBottomView extends Backbone.Marionette.Layout
  tagName: "div"

  template: "facts/fact_bottom"

  events:
    "click .is-popup": "popupClick",
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  regions:
    startConversationRegion: '.popup-content .start-conversation-container'
    addToChannelRegion: ".popup-content .add-to-channel-container"

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

  showPopup: (popup) ->
    @$('.popup-content .' + popup + '-container').show()

    @$('.transparent-layer').show()

    switch popup
      when "start-conversation"
        @startConversationRegion.show new StartConversationView(model: @model)
      when "add-to-channel"
        collection = @model.getOwnContainingChannels()
        collection.on "add", (channel) =>
          @model.addToChannel channel, {}

        collection.on "remove", (channel) =>
          @model.removeFromChannel channel, {}
          @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

        @addToChannelRegion.show new AddToChannelModalView(collection: collection, model: @model)

  closePopup: (e) ->
    @$('.popup-content > div').hide()
    @$('.transparent-layer').hide()
