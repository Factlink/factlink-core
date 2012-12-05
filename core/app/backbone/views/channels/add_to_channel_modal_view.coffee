class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  initialize: ->
    @alertErrorInit ['create_channel']

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @alertBindErrorEvent @addToChannelView

_.extend(AddToChannelModalView.prototype, Backbone.Factlink.AlertMixin)
