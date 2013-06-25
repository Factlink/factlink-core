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

  constructor: (options={}) ->
    @model = new ActionButtonState

    @className += ' btn-action btn'
    @className += ' btn-mini' if options.mini

    super

    el = options.listenToEl || @$el

    @bindTo el, 'click', @onClick, @
    @bindTo el, 'mouseenter', @onMouseEnter, @
    @bindTo el, 'mouseleave', @onMouseLeave, @

    @on 'render', @showCurrentState, @
    @bindTo @model, 'change', @render, @

  onClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.onClick()

  onMouseEnter: -> @model.set 'hovering', true
  onMouseLeave: -> @model.set 'hovering', false

  showCurrentState: ->
    hovering = @model.get('hovering')
    checked = @model.get('checked')

    @$el.toggleClass 'btn-danger', checked and hovering
    @$el.toggleClass 'btn-primary', hovering and not checked
    @$el.toggleClass 'btn-action-checked', checked

    @trigger 'render_state', hovering, checked
