class ActionButtonState extends Backbone.Model
  defaults:
    checked: false
    hovering: false

class window.ActionButtonView extends Backbone.Marionette.Layout
  template: 'generic/action_button'
  className: 'action-button'

  events:
    "click":   "onClick"
    "mouseenter": "onMouseEnter"
    "mouseleave": "onMouseLeave"

  ui:
    hoverState:      '.js-hover-state'
    defaultState:    '.js-default-state'
    primaryAction:   '.js-action-button-primary'
    secondaryAction: '.js-action-button-secondary'

  constructor: (args...) ->
    @stateModel = new ActionButtonState

    super(args...)

    @bindTo @stateModel, 'change:checked', @onCheckedChange
    @bindTo @stateModel, 'change:hovering', @onHoveringChange

    if @mini or @options.mini
      @template = 'generic/action_button_mini'

  onClick: (e) ->
    console.info 'onClick'
    e.preventDefault()
    e.stopPropagation()

    if @stateModel.get 'checked'
      @secondaryAction()
    else
      @primaryAction()

    @stateModel.set 'hovering', false

  onMouseEnter: ->
    @stateModel.set 'hovering', true

  onMouseLeave: ->
    @stateModel.set 'hovering', false

  onCheckedChange: ->
    @ui.primaryAction.toggle not @stateModel.get 'checked'
    @ui.secondaryAction.toggle @stateModel.get 'checked'

  buttonEnabled: ->
    # Must be implemented in the view that inherits from ActionButtonView
    Raven.captureMessage('buttonEnabled() must be implemented.')

  updateButton: ->
    @stateModel.set 'checked', @buttonEnabled()

  onHoveringChange: ->
    if @stateModel.get('hovering')
      @enableHoverState()
    else
      @disableHoverState()

  enableHoverState: ->
    if @stateModel.get('checked')
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
    @_disablePrimaryHoverState()
    @_disableSecondaryHoverState()

  _disablePrimaryHoverState: ->
    @ui.primaryAction.removeClass 'btn-primary'

  _disableSecondaryHoverState: ->
    @ui.defaultState.show()
    @ui.hoverState.hide()
    @ui.secondaryAction.removeClass 'btn-danger'

