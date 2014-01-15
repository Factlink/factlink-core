class window.AddToChannelView extends Backbone.Marionette.Layout
  className: 'add-to-channel'
  template: 'channels/add_to_channel'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  initialize: ->
    @collection = @model.getOwnContainingChannels(this)
    @collection.on "add", (channel) =>
      @model.addToChannel channel

    @collection.on "remove", (channel) =>
      @model.removeFromChannel channel

  onRender: ->
    mp_track "Factlink: Open repost modal"

    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView
      @listenTo @addToChannelView, 'error', ->
        FactlinkApp.NotificationCenter.error "The new #{Factlink.Global.t.topic} could not be created, please try again."
