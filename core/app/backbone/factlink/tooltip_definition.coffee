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

class Backbone.Factlink.TooltipDefinition extends Backbone.Marionette.View
  _closingtimeout: 500

  modelEvents:
    'change': '_toggleTooltip'

  initialize: -> @model = new Hovermodel

  render: ->
    @$target = @options.$container.find(@options.selector)
    @$target.hoverIntent
      timeout: @_closingtimeout
      over: => @model.set inTarget: true
      out:  => @model.set inTarget: false

  onClose: ->
    @_removeTooltip()
    @options.$container.off(".hoverIntent")

  _openTooltip: ->
    @_$tooltip = @options.makeTooltip @options.$container, @$target
    @_$tooltip.hoverIntent
      timeout: @_closingtimeout
      over: => @model.set inTooltip: true
      out:  => @model.set inTooltip: false

  _removeTooltip: ->
    @options.removeTooltip @options.$container, @$target, @_$tooltip
    delete @_$tooltip

  _toggleTooltip: ->
    if @_$tooltip
      @_removeTooltip() unless @model.hovered()
    else
      @_openTooltip() if @model.hovered()


