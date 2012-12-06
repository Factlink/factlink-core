class window.AddToChannelView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel'

  events:
    "click #add-to-channel": "openAddToChannelModal"
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  regions:
    modalRegion: '.add-to-channel-modal-region'

  openAddToChannelModal: ->
    @modalRegion.show new AddChannelToChannelsModalView(model: @model)
    @$('.add-to-channel-modal-region').show()
    @$('.transparent-layer').show()

  closePopup: (e) ->
    $('.add-to-channel-modal-region').hide()
    @$('.transparent-layer').hide()
