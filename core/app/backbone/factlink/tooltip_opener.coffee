#= require jquery.hoverIntent

# BUG/KNOWN LIMITATION: hoverIntent supports only one handler per element.
# This means that we cannot support multiple tooltips per target.
# The workaround is likely to not use hoverIntent (sigh), if we ever need this.

Backbone.Factlink ||= {}

class Hovermodel extends Backbone.Model
  defaults:
    inTooltip: false
    inTarget: false

  hovered: -> @get('inTarget') || @get('inTooltip')

class Backbone.Factlink.TooltipOpener extends Backbone.Marionette.View
  modelEvents:
    'change': '_toggleTooltip'

  initialize: -> @model = new Hovermodel

  render: -> @_hoverintent @options.$tooltipElement, 'inTarget', 7

  onClose: -> @_positionedRegion?.reset()

  _openTooltip: ->
    @_renderTooltip()
    @_positionedRegion.updatePosition()
    @_positionedRegion.fadeIn()

    @_tooltipOpened = true

  _hideTooltip: ->
    @_positionedRegion?.fadeOut()

    @_tooltipOpened = false

  _toggleTooltip: ->
    if @_tooltipOpened
      @_hideTooltip() unless @model.hovered()
    else
      @_openTooltip() if @model.hovered()

  _hoverintent: ($element, property, sensitivity) ->
    $element.hoverIntent
      sensitivity: sensitivity
      timeout: if @options.hoverIntent then 500 else 0
      over: => @model.set property, true
      out:  => @model.set property, false

    @on 'close', -> $element.off('.hoverIntent')

  _renderTooltip: ->
    return if @_positionedRegion?

    region_options = _.extend {fadeTime: 100} , @options.positioning
    @_positionedRegion = new Backbone.Factlink.PositionedRegion region_options
    @_positionedRegion.bindToElement @options.$tooltipElement, @options.$offsetParent

    @_positionedRegion.show new PopoverView _.extend {},
      contentView: @options.tooltipViewFactory(),
      @options.positioning

    if @options.stayWhenHoveringTooltip
      # Infinite sensitivity so that when moving into the tooltip,
      # 'inTooltip' is immediately set
      @_hoverintent @_positionedRegion.$el, 'inTooltip', Infinity
