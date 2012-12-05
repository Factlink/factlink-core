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
