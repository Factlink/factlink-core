Backbone.Factlink ||= {}

Backbone.Factlink.TooltipMixin =

  default_options:
    side: 'left'
    align: 'center'
    margin: 0

  tooltipAdd: (selector, title, text, options) ->
    options = _.extend @default_options, options

    @_tooltips ?= {}
    if @_tooltips[selector]?
      throw "Cannot call tooltipAdd multiple times with the same selector: #{selector}"

    view = new HelptextPopoverView _.extend {model: new Backbone.Model(title: title, text: text)}, options

    positionedRegion = new Backbone.Factlink.PositionedRegion options
    positionedRegion.crossFade view

    container = options.container || @$el

    @_tooltips[selector] = { positionedRegion, container, view }

    unless @isClosed
      @tooltipBindAll()

    @on 'render', @tooltipBindAll
    @on 'close', @tooltipResetAll

  tooltipRemove: (selector, fade=true) ->
    tooltip = @_tooltips[selector]
    if tooltip?
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
