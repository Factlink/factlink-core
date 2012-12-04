class window.AddToChannelView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel'

  events:
    "click #add-to-channel": "openAddToChannelModal"
    "click .transparent-layer": "closePopup",
    "click .close-popup": "closePopup"

  regions:
    modalRegion: '.add-to-channel-modal-region'

  openAddToChannelModal: ->
    collection = @model.getOwnContainingChannels()
    collection.on "add", (channel) =>
      @model.addToChannel channel, {}

    collection.on "remove", (channel) =>
      @model.removeFromChannel channel, {}
      @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

    @modalRegion.show new AddToChannelModalView collection: collection
    @$('.add-to-channel-modal-region').show()
    @$('.transparent-layer').show()

  closePopup: (e) ->
    $('.add-to-channel-modal-region').hide()
    @$('.transparent-layer').hide()
