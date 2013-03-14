class window.FollowChannelButtonView extends Backbone.Marionette.Layout
  template: 'channels/follow_channel_button'

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

  follow: (e) ->
    @justFollowed = true
    @model.follow()
    e.preventDefault()
    e.stopPropagation()

  unfollow: (e) ->
    @model.unfollow()
    e.preventDefault()
    e.stopPropagation()

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
