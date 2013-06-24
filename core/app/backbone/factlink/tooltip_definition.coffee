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

class HoverState extends Backbone.Model
  defaults:
    inTooltip: false
    inTarget: false

  hovered: -> @get('inTarget') || @get('inTooltip')


class Backbone.Factlink.TooltipDefinition
  closingtimeout: 500

  constructor: (options) ->
    @_options = options
    @state = new HoverState
    @state.on 'change', => @toggleTooltip()

  render: ->
    @_options.$container.hoverIntent
      timeout: @closingtimeout
      selector: @_options.selector
      over: => @state.set inTarget: true
      out:  => @state.set inTarget: false
    @$target = @_options.$container.find(@_options.selector)

  close: ->
    @removeTooltip()
    @_options.$container.off(".hoverIntent")

  removeTooltip: =>
    @_options.removeTooltip @_options.$container, @$target, @_$tooltip
    delete @_$tooltip

  start_tooltip: ->
    @_$tooltip = @_options.makeTooltip @_options.$container, @$target
    @_$tooltip.hoverIntent
      timeout: @closingtimeout
      over: => @state.set inTooltip: true
      out:  => @state.set inTooltip: false

  toggleTooltip: ->
    if @_$tooltip
      @removeTooltip() unless @state.hovered()
    else
      @start_tooltip() if @state.hovered()


