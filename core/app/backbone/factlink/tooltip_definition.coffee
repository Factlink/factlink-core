#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}

class Backbone.Factlink.TooltipDefinition
  defaults:
    closingtimeout: 500

  constructor: (options) ->
    @_options = _.defaults options, @defaults
    @state = new Backbone.Model
      inTooltip: false
      inTarget: false

  render: ->
    @_options.$container.hoverIntent
      timeout: @_options.closingtimeout
      selector: @_options.selector
      over:(e) => @_hoverTarget e, true
      out: (e) => @_hoverTarget e, false

  close: ->
    @removeTooltip()
    @_options.$container.off(".hoverIntent") #unfortunately, we can't do better than this.

  removeTooltip: =>
    @_options.removeTooltip @_options.$container, @$target, @_$tooltip
    delete @_$tooltip

  _hoverTarget: (e, target_is_hovered) ->
    if @_$tooltip
      @setTargetHover target_is_hovered
    else if target_is_hovered
     @$target = $(e.currentTarget)
     @start_tooltip @_options, @$target

  start_tooltip: (options, $target) ->
    @state.set('inTarget', true)
    @_$tooltip = options.makeTooltip options.$container, $target
    @_$tooltip.hoverIntent
      timeout: options.closingtimeout
      over: => @setTooltipHover(true)
      out: => @setTooltipHover(false)

  _check: -> @removeTooltip() unless @hovered()

  hovered: ->
    @state.get('inTarget') || @state.get('inTooltip')

  setTooltipHover: (state) ->
    @state.set('inTooltip',state)
    @_check()

  setTargetHover: (state) ->
    @state.set('inTarget', state)
    @_check()

