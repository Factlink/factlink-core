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

class window.ActionButtonView extends Backbone.Marionette.ItemView
  tagName: 'button'
  template: 'generic/action_button'

  events:
    "click":   "onClick"
    "mouseenter": "onMouseEnter"
    "mouseleave": "onMouseLeave"

  templateHelpers: =>
    checked: => @stateModel.get('checked')
    hovering: => @stateModel.get('hovering')

  constructor: (options={}) ->
    @stateModel = new ActionButtonState

    @className += ' action-button btn'
    if @mini or options.mini
      @className += ' btn-mini'

    super

    @bindTo @stateModel, 'change:checked', @onCheckedChange
    @bindTo @stateModel, 'change:hovering', @onHoveringChange
    @bindTo @stateModel, 'change', @render

  onClick: (e) ->
    return if @options.noEvents
    e.preventDefault()
    e.stopPropagation()
    @stateModel.onClick()

  onMouseEnter: ->
    return if @options.noEvents
    @stateModel.set 'hovering', true

  onMouseLeave: ->
    return if @options.noEvents
    @stateModel.set 'hovering', false

  onRender: ->
    @$el.removeClass 'btn-primary btn-danger'

    if @stateModel.get('hovering')
      if @stateModel.get('checked')
        @$el.addClass 'btn-danger'
      else
        @$el.addClass 'btn-primary'
