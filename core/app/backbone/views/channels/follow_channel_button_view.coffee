class window.FollowChannelButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click .js-follow-topic-button": "follow"
    "click .js-unfollow-topic-button": "unfollow"

    "mouseleave": "disableHoverState"
    "mouseenter": "enableHoverState"

  ui:
    defaultButton:  '.js-default-state'
    hoverButton:    '.js-hover-state'
    unfollowButton: '.js-unfollow-topic-button'

  initialize: ->
    @bindTo @model, 'change', @updateButton, @

  follow: ->
    @justFollowed = true
    @model.follow()

  unfollow: -> @model.unfollow()

  onRender: -> @updateButton()

  updateButton: =>
    added = @model.get('followed?')

    @$('.js-unfollow-topic-button').toggle added
    @$('.js-follow-topic-button').toggle not added

  enableHoverState: ->
    return if @justFollowed
    return unless @model.get('followed?')
    @ui.defaultButton.hide()
    @ui.hoverButton.show()
    @ui.unfollowButton.addClass 'btn-danger'

  disableHoverState: ->
    delete @justFollowed
    @ui.defaultButton.show()
    @ui.hoverButton.hide()
    @ui.unfollowButton.removeClass 'btn-danger'
