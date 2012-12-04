class window.FactBottomView extends Backbone.Marionette.Layout
  tagName: "div"

  className: "fact-bottom"

  template: "facts/fact_bottom"

  events:
    "click .is-popup": "popupClick",
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  regions:
    startConversationRegion: '.popup-content .start-conversation-container'
    addToChannelRegion: ".popup-content .add-to-channel-form"
    # Move this to own
    suggestedChannelsRegion: ".popup-content .add-to-channel-suggested-channels-region"

  templateHelpers: ->
    fact_url_host: ->
      if @fact_url?
        url = document.createElement('a')
        url.href = @fact_url

        url.host

  renderAddToChannel: ->
    if @addToChannelView == `undefined`
      @addToChannelView = new AutoCompleteChannelsView
                               collection: new OwnChannelCollection()
      _.each @model.getOwnContainingChannels(), (ch) =>
        @addToChannelView.collection.add ch  if ch.get("type") is "channel"

      @addToChannelView.on "addChannel", (channel) =>
        @model.addToChannel channel, {}

      @addToChannelView.on "removeChannel", (channel) =>
        @model.removeFromChannel channel, {}
        @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

      @addToChannelRegion.show @addToChannelView

  renderSuggestedChannels: ->
    suggested_channels = new SuggestedChannels()
    suggested_channels.fetch()
    # TODO 0412
    # Only suggest channelx that can be added, something like:
    # collectionDifference suggested_channels, channels_that_fact_is_in
    suggestions = new SuggestedChannelsView
                        collection: suggested_channels
    @suggestedChannelsRegion.show suggestions

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
        @renderAddToChannel()
        @renderSuggestedChannels()

  closePopup: (e) ->
    @$('.popup-content > div').hide()
    @$('.transparent-layer').hide()
