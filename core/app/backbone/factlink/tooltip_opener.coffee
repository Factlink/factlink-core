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

  render: -> @_hoverintent @options.$tooltipElement, 'inTarget'

  onClose: -> @_removeTooltip() if @_opened

  _openTooltip: ->
    @_positionedRegion().bindToElement @options.$tooltipElement, @options.$offsetParent
    @_positionedRegion().show @_tooltipView()
    @_positionedRegion().updatePosition()

    @_hoverintent @_positionedRegion().$el, 'inTooltip' if @options.stayWhenHoveringTooltip

    @_tooltipOpened = true

  _removeTooltip: ->
    @_positionedRegion().resetFade()

    @_tooltipOpened = false

  _toggleTooltip: ->
    if @_tooltipOpened
      @_removeTooltip() unless @model.hovered()
    else
      @_openTooltip() if @model.hovered()

  _hoverintent: ($element, property) ->
    $element.hoverIntent
      timeout: if @options.hoverIntent then 500 else 0
      over: => @model.set property, true
      out:  => @model.set property, false

    @on 'close', -> $element.off('.hoverIntent')

  _tooltipView: ->
    tooltipOptions = _.extend {},
      contentView: @options.tooltipViewFactory(),
      @options.positioning
    new PopoverView tooltipOptions

  _positionedRegion: ->
    return @__positionedRegion if @__positionedRegion?

    region_options = _.extend {fadeTime: 100} , @options.positioning
    @__positionedRegion = new Backbone.Factlink.PositionedRegion region_options
