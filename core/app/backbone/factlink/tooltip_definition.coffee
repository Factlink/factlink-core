#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}

class Backbone.Factlink.TooltipDefinition
  defaults = closingtimeout: 500
  counter = 0

  constructor: (options) ->
    @_options = _.defaults options, defaults
    @_uid =
    @_uidStr = 'tooltip_Uid-' + counter++

  render: ->
    @_options.$container.hoverIntent
      timeout: @_options.closingtimeout
      selector: @_options.selector
      over: @_hoverTarget true
      out: @_hoverTarget false

  close: ->
    @removeTooltip()
    @_options.$container.off(".hoverIntent") #unfortunately, we can't do better than this.

  _openInstance: ($target) ->
    @$target = $target
    @start_tooltip @_options, @$target

  removeTooltip: =>
    @_options.removeTooltip @_options.$container, @$target, @_$tooltip
    delete @we_have_tooltip

  _hoverTarget: (target_is_hovered) -> (e) =>
    if @we_have_tooltip
      @setTargetHover target_is_hovered
    else if target_is_hovered
      @_openInstance $(e.currentTarget)

  start_tooltip: (options, $target) ->
    @we_have_tooltip = true
    @_inTooltip = false
    @_inTarget = true #opened on hover over target

    @_$tooltip = options.makeTooltip options.$container, $target
    @_$tooltip.hoverIntent
      timeout: options.closingtimeout
      over: => @setTooltipHover(true)
      out: => @setTooltipHover(false)

  _check: -> @removeTooltip() if !(@_inTarget || @_inTooltip)

  setTooltipHover: (state) ->
    @_inTooltip = state
    @_check()

  setTargetHover: (state) ->
    @_inTarget = state
    @_check()

