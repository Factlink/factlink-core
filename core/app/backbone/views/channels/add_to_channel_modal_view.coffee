class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  onRender: ->
    if @addToChannelView == `undefined`
      @addToChannelView = new AutoCompleteChannelsView
                               collection: @model.getOwnContainingChannels()

      @addToChannelView.on "addChannel", (channel) =>
        @model.addToChannel channel, {}

      @addToChannelView.on "removeChannel", (channel) =>
        @model.removeFromChannel channel, {}
        @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

      @addToChannelRegion.show @addToChannelView
