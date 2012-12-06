class window.AddChannelToChannelsModalView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  events:
    "click #add-to-channel": "openAddToChannelModal"
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  initialize: ->
    @alertErrorInit ['create_channel', 'add_channel', 'remove_channel']

    @collection = @model.getOwnContainingChannels()

    @collection.on "add", (channel) =>
      @alertHide()
      channel.addToChannel @model,
        error: =>
          @alertError 'add_channel'
          @collection.remove channel, silent: true
      @updateButton()

    @collection.on "remove", (channel) =>
      @alertHide()
      channel.removeFromChannel @model,
        error: =>
          @alertError 'remove_channel'
          @collection.add channel, silent: true
      @updateButton()

    @updateButton()

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @alertBindErrorEvent @addToChannelView

  updateButton: =>
    if(@collection.length == 0)
      @$('.added-to-channel-button-label').hide()
      @$('.add-to-channel-button-label').show()
    else
      @$('.add-to-channel-button-label').hide()
      @$('.added-to-channel-button-label').show()

  openAddToChannelModal: ->
    @$('.add-to-channel-modal-region').show()
    @$('.transparent-layer').show()

  closePopup: (e) ->
    $('.add-to-channel-modal-region').hide()
    @$('.transparent-layer').hide()

_.extend(AddChannelToChannelsModalView.prototype, Backbone.Factlink.AlertMixin)
