#= require jquery.hoverIntent

# BUG/KNOWN LIMITATIONS
#
# hoverIntent supports only one handler per event.
# This means that you certainly cannot support
# more than 1 tooltip per element, but perhaps also not more
# than one per owner.  The workaround is likely to not use
# hoverIntent (sigh), if we ever need this.
#
# unfortunately, when we close the hoverIntent,
# we close all hoverintents on the container

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

  render: ->
    @$target = @options.$container.find(@options.selector)
    @_hoverintent @$target, 'inTarget'

  onClose: ->
    @_removeTooltip()
    @options.$target.off(".hoverIntent")

  _openTooltip: ->
    @_$tooltip = @options.tooltipCreator.createTooltip @$target
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

