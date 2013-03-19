Backbone.Factlink ||= {}

Backbone.Factlink.TooltipMixin =

  tooltipAdd: (selector, title, text, options) ->
    options = _.extend {side: 'left', align: 'center', margin: 0}, options

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

  tooltipRemove: (selector) ->
    tooltip = @_tooltips[selector]
    if tooltip?
      tooltip.positionedRegion.resetFade()
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
      tooltip.positionedRegion.reset()

  tooltip: (selector) -> @_tooltips[selector]
