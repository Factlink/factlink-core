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

  constructor: (options={}) ->
    @model = new ActionButtonState

    @className += ' btn-action btn'
    @className += ' btn-mini' if options.mini

    super

    @bindTo @model, 'change', @render

  onClick: (e) ->
    return if @options.noEvents
    e.preventDefault()
    e.stopPropagation()
    @model.onClick()

  onMouseEnter: ->
    return if @options.noEvents
    @model.set 'hovering', true

  onMouseLeave: ->
    return if @options.noEvents
    @model.set 'hovering', false

  onRender: ->
    @$el.removeClass 'btn-primary btn-danger'

    if @model.get('hovering')
      if @model.get('checked')
        @$el.addClass 'btn-danger'
      else
        @$el.addClass 'btn-primary'

    @$el.toggleClass 'btn-action-checked', @model.get('checked')
