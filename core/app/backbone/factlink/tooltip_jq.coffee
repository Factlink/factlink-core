#= require jquery.hoverIntent

Backbone.Factlink ||= {}
do ->
  PositionedRegion = Backbone.Factlink.PositionedRegion

  defaults =
    side: 'left'
    align: 'center'
    closingtimeout: 300

    #$target: owner
    #mkTooltip: $target -> $tooltip
    #rmTooltip: $target, $tooltip ->

  hoverStateByEvent =
    mouseenter: true
    mouseleave: false


  Backbone.Factlink.TooltipJQ = (cfg) ->
    $target = cfg.$target
    inTarget = inTooltip = showing = false
    $tooltip = null
    cfg = $.extend defaults, cfg

    updateTooltip = ->
      shouldShow = inTarget || inTooltip
      if shouldShow && !showing then
        showing = true
        $tooltip = cfg.mkTooltip $target
        $tooltip.hoverIntent
          timeout: cfg.closingtimeout
          over: hoverTooltip
      else if showing && !shouldShow then
        showing = false
        $tooltip = null
        cfg.rmTooltip $target, $tooltip

    hoverTarget = (e) ->
      console.log e
      inTarget = hoverStateByEvent[e.type]

    hoverTooltip = (e) ->
      console.log e
      inTooltip = hoverStateByEvent[e.type]

    $target.hoverIntent
      timeout: cfg.closingtimeout
      over: hoverTarget
