#= require ./add_channel_to_channels_modal_view

class window.AddChannelToChannelsButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click #add-to-channel": "openAddToChannelModal"

  initialize: ->
    @collection = @model.getOwnContainingChannels()
    @bindTo @collection, "add remove", (channel) => @updateButton()

  onRender: ->
    @updateButton()

  updateButton: =>
    if(@collection.length == 0)
      @$('.added-to-channel-button-label').hide()
      @$('.add-to-channel-button-label').show()
    else
      @$('.add-to-channel-button-label').hide()
      @$('.added-to-channel-button-label').show()

  openAddToChannelModal: ->
    e.stopImmediatePropagation()
    e.preventDefault()

    FactlinkApp.Modal.show 'Add to Channels',
      new AddChannelToChannelsModalView model: @model, collection: @collection
