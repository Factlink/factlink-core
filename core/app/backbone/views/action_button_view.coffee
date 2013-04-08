class window.ActionButtonView extends Backbone.Marionette.Layout
  template: 'generic/action_button'

  events:
    "click .js-action-button-primary":   "primaryActionWrapper"
    "click .js-action-button-secondary": "secondaryAction"

    "mouseleave": "disableHoverState"
    "mouseenter": "enableHoverState"

  ui:
    hoverState:      '.js-hover-state'
    defaultState:    '.js-default-state'
    primaryAction:   '.js-action-button-primary'
    secondaryAction: '.js-action-button-secondary'

  updateButton: =>
    added = @buttonEnabled()
    @ui.primaryAction.toggle not added
    @ui.secondaryAction.toggle added

  buttonEnabled: ->
    # Must be implemented in the view that inherits from ActionButtonView
    console.error 'buttonEnabled() must be implemented.'

  enableHoverState: ->
    return if @justClicked
    return unless @buttonEnabled()
    @ui.defaultState.hide()
    @ui.hoverState.show()
    @ui.secondaryAction.addClass 'btn-danger'

  disableHoverState: ->
    delete @justClicked
    @ui.defaultState.show()
    @ui.hoverState.hide()
    @ui.secondaryAction.removeClass 'btn-danger'

  primaryActionWrapper: (e) ->
    @justClicked = true
    @primaryAction(e)
