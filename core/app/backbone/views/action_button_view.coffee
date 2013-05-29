class window.ActionButtonView extends Backbone.Marionette.Layout
  template: 'generic/action_button'
  className: 'action-button'

  events:
    "click .js-action-button-primary":   "primaryActionWrapper"
    "click .js-action-button-secondary": "secondaryActionWrapper"

    "mouseleave": "disableHoverState"
    "mouseenter": "enableHoverState"

  ui:
    hoverState:      '.js-hover-state'
    defaultState:    '.js-default-state'
    primaryAction:   '.js-action-button-primary'
    secondaryAction: '.js-action-button-secondary'

  constructor: (args...) ->
    super(args...)
    if @mini or @options.mini
      @template = 'generic/action_button_mini'

  updateButton: ->
    added = @buttonEnabled()
    @ui.primaryAction.toggle not added
    @ui.secondaryAction.toggle added

  buttonEnabled: ->
    # Must be implemented in the view that inherits from ActionButtonView
    Raven.captureMessage('buttonEnabled() must be implemented.')

  enableHoverState: ->
    return if @justClicked
    if @buttonEnabled()
      @_enableSecondaryHoverState()
    else
      @_enablePrimaryHoverState()
      
  _enablePrimaryHoverState: ->
    @ui.primaryAction.addClass 'btn-primary'

  _enableSecondaryHoverState: ->
    @ui.defaultState.hide()
    @ui.hoverState.show()
    @ui.secondaryAction.addClass 'btn-danger'

  disableHoverState: ->
    delete @justClicked
    @_disablePrimaryHoverState()
    @_disableSecondaryHoverState()

  _disablePrimaryHoverState: ->
    @ui.primaryAction.removeClass 'btn-primary'

  _disableSecondaryHoverState: ->
    @ui.defaultState.show()
    @ui.hoverState.hide()
    @ui.secondaryAction.removeClass 'btn-danger'

  primaryActionWrapper: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @justClicked = true
    @primaryAction(e)

  secondaryActionWrapper: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @secondaryAction(e)
