class ActionButtonState extends Backbone.Model
  defaults:
    checked: false
    hovering: false
    loaded: false

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

    @className += ' button'
    @className += ' button button-small' if options.mini

    super

    @$listenToEl = options.$listenToEl || @$el
    @bindInteractionEvents()

  bindInteractionEvents: ->
    @$listenToEl.on 'click', (e) => @onClick(e)
    @$listenToEl.on 'mouseenter', => @onMouseEnter()
    @$listenToEl.on 'mouseleave', => @onMouseLeave()

    @listenTo @model, 'change', @render
    @on 'render', @showCurrentState, @

  onClose: ->
    @$listenToEl.off 'click'
    @$listenToEl.off 'mouseenter'
    @$listenToEl.off 'mouseleave'

  onClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    return unless @model.get('loaded')

    @model.onClick()

  onMouseEnter: -> @model.set 'hovering', true
  onMouseLeave: -> @model.set 'hovering', false

  showCurrentState: ->
    hovering = @model.get('hovering')
    checked = @model.get('checked')
    loaded = @model.get('loaded')

    @$el.toggleClass 'disabled', not loaded

    @$el.toggleClass 'button-danger', hovering and checked and loaded
    @$el.toggleClass 'button-confirm', hovering and not checked and loaded
    @$el.toggleClass 'button-action-checked', checked and loaded

    @trigger 'render_state', loaded, hovering, checked
