#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler per element.
#This means that we cannot support multiple tooltips per target.
#The workaround is likely to not use hoverIntent (sigh), if we ever need this.

Backbone.Factlink ||= {}

closingtimeout = 500

Backbone.Factlink.defineTooltip = (options) ->
  #options:
  #$target: what to hover over
  #showTooltip: $target -> $tooltip
  #hideTooltip: $target, $tooltip ->

  $target = options.$target
  $tooltip = null
  mouseInTooltip = mouseInTarget = false

  openTooltip =  ->
    $tooltip = options.showTooltip $target
    $tooltip.hoverIntent
      timeout: closingtimeout
      over: -> mouseInTooltip = true; check()
      out: -> mouseInTooltip = false; check()

  closeTooltip = ->
    options.hideTooltip $target, $tooltip
    $tooltip = null

  check = ->
    if $tooltip && !(mouseInTarget || mouseInTooltip)
      closeTooltip()
    else if !$tooltip && (mouseInTarget || mouseInTooltip)
      openTooltip()

  $target.hoverIntent
    timeout: closingtimeout
    over: -> mouseInTarget = true; check()
    out: -> mouseInTarget = false; check()

  close: ->
    closeTooltip() if $tooltip
    $target.off(".hoverIntent")
