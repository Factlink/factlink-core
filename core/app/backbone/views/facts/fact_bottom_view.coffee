class window.FactBottomView extends Backbone.Marionette.Layout
  tagName: "div"

  template: "facts/fact_bottom"

  events:
    "click .is-popup": "popupClick",
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  regions:
    addToChannelRegion: ".popup-content .add-fact-to-channel-container"

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
    switch popup
      when "start-conversation"
        FactlinkApp.Modal.show 'Send a message',
          new StartConversationView(model: @model)
      when "add-fact-to-channel"
        @$('.popup-content .' + popup + '-container').show()
        @$('.transparent-layer').show()

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
