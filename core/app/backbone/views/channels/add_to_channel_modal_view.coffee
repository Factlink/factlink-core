class window.AddChannelToChannelsModalView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  onRender: ->
    unless @addToChannelView
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView


class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  onRender: ->
    unless @addToChannelView
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView
