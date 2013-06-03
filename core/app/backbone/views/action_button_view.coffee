class ActionButtonState extends Backbone.Model
  defaults:
    checked: false
    hovering: false

  onClick: ->
    if @get('checked')
      @trigger 'click:checked'
    else
      @trigger 'click:unchecked'
    @set 'hovering', false

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
    e.preventDefault()
    e.stopPropagation()
    @stateModel.onClick()

  onMouseEnter: ->
    @stateModel.set 'hovering', true

  onMouseLeave: ->
    @stateModel.set 'hovering', false

  onRender: ->
    @onCheckedChange()
    @onHoveringChange()

  onCheckedChange: ->
    @ui.primaryAction.toggle not @stateModel.get 'checked'
    @ui.secondaryAction.toggle @stateModel.get 'checked'

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

