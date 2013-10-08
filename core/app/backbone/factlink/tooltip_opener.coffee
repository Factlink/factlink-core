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

  onClose: -> @_removeTooltip() if @_$tooltip

  _openTooltip: ->
    @_$tooltip = @options.tooltipCreator.createTooltip @options.$tooltipElement
    @_hoverintent @_$tooltip, 'inTooltip' if @options.stayWhenHoveringTooltip

  _removeTooltip: ->
    @options.tooltipCreator.removeTooltip()
    delete @_$tooltip

  _toggleTooltip: ->
    if @_$tooltip
      @_removeTooltip() unless @model.hovered()
    else
      @_openTooltip() if @model.hovered()

  _hoverintent: ($element, property) ->
    $element.hoverIntent
      timeout: if @options.hoverIntent then 500 else 0
      over: => @model.set property, true
      out:  => @model.set property, false

    @on 'close', -> $element.off('.hoverIntent')

