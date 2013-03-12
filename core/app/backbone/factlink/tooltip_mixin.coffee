Backbone.Factlink ||= {}

Backbone.Factlink.TooltipMixin =

  tooltipAdd: (selector, title, text, options) ->
    @_tooltips ?= {}
    side = options.side || 'left'

    if @_tooltips[selector]?
      throw "Cannot call tooltipAdd multiple times with the same selector: #{selector}"

    view = new HelptextPopoverView(model: new Backbone.Model(title: title, text: text), side: side)

    positionedRegion = new Backbone.Factlink.PositionedRegion _.extend({}, options, side: side)
    positionedRegion.show view

    offsetParent = options.offsetParent || @$el

    @_tooltips[selector] = { positionedRegion, offsetParent, view }

    unless @isClosed
      @tooltipBindAll()

    @on 'render', @tooltipBindAll
    @on 'close', @tooltipResetAll

  tooltipRemove: (selector) ->
    tooltip = @_tooltips[selector]
    tooltip.positionedRegion.reset()
    delete @_tooltips[selector]

  tooltipBindAll: ->
    for selector, tooltip of @_tooltips
      $bindEl = @$(selector).first()
      tooltip.positionedRegion.bindToElement($bindEl, tooltip.offsetParent)

    @tooltipUpdateAll()

  tooltipUpdateAll: ->
    for selector, tooltip of @_tooltips
      tooltip.positionedRegion.updatePosition()

  tooltipResetAll: ->
    for selector, tooltip of @_tooltips
      tooltip.positionedRegion.reset()

  tooltip: (selector) ->
    @_tooltips?[selector]
