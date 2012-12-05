class window.AddChannelToChannelsModalView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  initialize: ->
    @collection = @model.getOwnContainingChannels()

    @collection.on "add", (channel) =>
      @hideError()
      channel.addToChannel @model,
        error: =>
          @showError 'add_channel'
          @collection.remove channel, silent: true

    @collection.on "remove", (channel) =>
      @hideError()
      channel.removeFromChannel @model,
        error: =>
          @showError 'remove_channel'
          @collection.add channel, silent: true

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @bindTo @addToChannelView, 'error', => @showError 'create_channel'

  showError: (type) ->
    @$('.js-error').addClass 'hide'
    @$('.js-error-type-' + type).removeClass 'hide' if type?

  hideError: -> @showError null


class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @bindTo @addToChannelView, 'error', => @showError 'create_channel'

  showError: (type) ->
    @$('.js-error').addClass 'hide'
    @$('.js-error-type-' + type).removeClass 'hide' if type?

  hideError: -> @showError null
