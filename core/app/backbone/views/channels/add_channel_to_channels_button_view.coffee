#= require ./add_channel_to_channels_modal_view

class window.AddChannelToChannelsButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click .js-add-to-channel-button": "openAddToChannelModal"

  initialize: ->
    @collection = @model.getOwnContainingChannels(this)
    @bindTo @collection, "add remove reset", (channel) => @updateButton()

  onRender: ->
    @updateButton()

  updateButton: =>
    added = @collection.length > 0

    @$('.added-to-channel-button-label').toggle added
    @$('.add-to-channel-button-label').toggle not added

  openAddToChannelModal: (e) ->
    e.stopImmediatePropagation()
    e.preventDefault()

    FactlinkApp.Modal.show 'Add to Channels',
      new AddChannelToChannelsModalView
            model: @model,
            collection: @collection
            suggestions: @options.suggested_topics
