class ActualModalView extends Backbone.Marionette.Layout
  template:
    text: """
      <div class="alert alert-error js-alert js-alert-error-create_channel hide">
        The new channel could not be created, please try again.
        <a class="close" href="#" data-dismiss="alert">x</a>
      </div>
      <div class="alert alert-error js-alert js-alert-error-add_channel hide">
        The channel could not be added, please try again.
        <a class="close" href="#" data-dismiss="alert">x</a>
      </div>
      <div class="alert alert-error js-alert js-alert-error-remove_channel hide">
        The channel could not be removed, please try again.
        <a class="close" href="#" data-dismiss="alert">x</a>
      </div>

      <strong>Add this channel to one or more channels:</strong>
      <div class="add-to-channel-form"></div>
      <input type="submit" class="btn btn-primary pull-right close-popup" value="Done">
        """

  regions:
    addToChannelRegion: ".add-to-channel-form"

  initialize: ->
    @alertErrorInit ['create_channel', 'add_channel', 'remove_channel']

    @collection.on "add", (channel) =>
      @alertHide()
      channel.addToChannel @model,
        error: =>
          @alertError 'add_channel'
          @collection.remove channel, silent: true

    @collection.on "remove", (channel) =>
      @alertHide()
      channel.removeFromChannel @model,
        error: =>
          @alertError 'remove_channel'
          @collection.add channel, silent: true

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @alertBindErrorEvent @addToChannelView

_.extend(ActualModalView.prototype, Backbone.Factlink.AlertMixin)

class window.AddChannelToChannelsModalView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_modal'

  events:
    "click #add-to-channel": "openAddToChannelModal"

  initialize: ->
    @collection = @model.getOwnContainingChannels()
    @collection.on "add remove", (channel) => @updateButton()

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
    FactlinkApp.Modal.show 'Add to Channels',
      new ActualModalView model: @model, collection: @collection
