#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler per element.
#This means that we cannot support multiple tooltips per target.
#The workaround is likely to not use hoverIntent (sigh), if we ever need this.

Backbone.Factlink ||= {}

class Hovermodel extends Backbone.Model
  defaults:
    inTooltip: false
    inTarget: false

  hovered: -> @get('inTarget') || @get('inTooltip')

class Backbone.Factlink.TooltipOpener extends Backbone.Marionette.View
  _closingtimeout: 500

  modelEvents:
    'change': '_toggleTooltip'

  initialize: -> @model = new Hovermodel

  render: -> @_hoverintent @$el, 'inTarget'

  onClose: -> @_removeTooltip() if @model.hovered()

  _openTooltip: ->
    @_$tooltip = @options.tooltipCreator.createTooltip @$el
    @_hoverintent @_$tooltip, 'inTooltip'

  _removeTooltip: ->
    @options.tooltipCreator.removeTooltip()
    delete @_$tooltip

  _toggleTooltip: ->
    if @_$tooltip
      @_removeTooltip() unless @model.hovered()
    else
      @_openTooltip() if @model.hovered()

  _hoverintent: ($element, property)->
    $element.hoverIntent
      timeout: @_closingtimeout
      over: => @model.set property, true
      out:  => @model.set property, false

    @on 'close', -> $element.off('.hoverIntent')

