Backbone.Factlink ||= {}

oldZIndex = 0
focusElement = (element) ->
  oldZIndex = $(element).css('z-index')
  $(element).css('z-index', 110)

unFocusElement = (element) ->
  $(element).css('z-index', oldZIndex)
  oldZIndex = 0

Backbone.Factlink.TooltipMixin =

  default_options:
    side: 'left'
    align: 'center'
    show_overlay: false
    focus_on: null
    margin: 0

  tooltipAdd: (selector, title, text, options) ->
    @tooltip_options = _.extend {}, @default_options, options

    @_tooltips ?= {}
    if @_tooltips[selector]?
      throw "Cannot call tooltipAdd multiple times with the same selector: #{selector}"

    view = new HelptextPopoverView _.extend {model: new Backbone.Model(title: title, text: text)}, @tooltip_options

    FactlinkApp.Overlay.show() if @tooltip_options['show_overlay']
    focusElement(@tooltip_options['focus_on']) if @tooltip_options['focus_on']

    positionedRegion = new Backbone.Factlink.PositionedRegion @tooltip_options
    positionedRegion.crossFade view

    container = @tooltip_options.container || @$el

    @_tooltips[selector] = { positionedRegion, container, view }

    @tooltipBindAll() unless @isClosed
    @on 'render', @tooltipBindAll
    @on 'close', @tooltipResetAll

  tooltipRemove: (selector, fade=true) ->
    tooltip = @_tooltips[selector]
    if tooltip?
      FactlinkApp.Overlay.hide() if @tooltip_options['show_overlay']
      unFocusElement(@tooltip_options['focus_on']) if @tooltip_options['focus_on']

      if fade
        tooltip.positionedRegion.resetFade()
      else
        tooltip.positionedRegion.reset()

      delete @_tooltips[selector]

  tooltipBindAll: ->
    for selector, tooltip of @_tooltips
      $bindEl = @$(selector).first()
      tooltip.positionedRegion.bindToElement($bindEl, tooltip.container)

    @tooltipUpdateAll()

  tooltipUpdateAll: ->
    for selector, tooltip of @_tooltips
      tooltip.positionedRegion.updatePosition()

  tooltipResetAll: ->
    for selector, tooltip of @_tooltips
      @tooltipRemove(selector, false)

  tooltip: (selector) -> @_tooltips[selector]
