class window.FollowChannelButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click .js-add-to-channel-button": "toggleFollow"

  toggleFollow: ->
    @model.follow()
