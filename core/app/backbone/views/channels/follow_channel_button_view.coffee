class window.FollowChannelButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click .js-add-to-channel-button": "toggleFollow"

  initialize: ->
    @bindTo @model, 'change', @updateButton, @

  toggleFollow: ->
    @model.follow()

  onRender: -> @updateButton()

  updateButton: =>
    added = @model.get('followed?')

    @$('.added-to-channel-button-label').toggle added
    @$('.add-to-channel-button-label').toggle not added
