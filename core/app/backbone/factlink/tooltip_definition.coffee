#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}

class HoverState extends Backbone.Model
  defaults:
    inTooltip: false
    inTarget: false

  hovered: ->
    @get('inTarget') || @get('inTooltip')


class Backbone.Factlink.TooltipDefinition
  defaults:
    closingtimeout: 500

  constructor: (options) ->
    @_options = _.defaults options, @defaults
    @state = new HoverState
    @state.on 'change', => @toggleTooltip()

  render: ->
    @_options.$container.hoverIntent
      timeout: @_options.closingtimeout
      selector: @_options.selector
      over:(e) => @state.set inTarget: true
      out: (e) => @state.set inTarget: false
    @$target = @_options.$container.find(@_options.selector)

  close: ->
    @removeTooltip()
    @_options.$container.off(".hoverIntent") #unfortunately, we can't do better than this.

  removeTooltip: =>
    @_options.removeTooltip @_options.$container, @$target, @_$tooltip
    delete @_$tooltip

  start_tooltip: (options, $target) ->
    @_$tooltip = options.makeTooltip options.$container, $target
    @_$tooltip.hoverIntent
      timeout: options.closingtimeout
      over: => @state.set inTooltip: true
      out: => @state.set inTooltip: false

  toggleTooltip: ->
    if @_$tooltip
      @removeTooltip() unless @state.hovered()
    else
      start_tooltip if @state.hovered()


