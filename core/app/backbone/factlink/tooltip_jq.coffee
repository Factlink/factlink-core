#= require jquery.hoverIntent

Backbone.Factlink ||= {}
do ->
  PositionedRegion = Backbone.Factlink.PositionedRegion

  defaults =
    side: 'left'
    align: 'center'
    closingtimeout: 300

    #$el: owner
    #selector: what to hover over
    #mkTooltip: $target -> $tooltipEl
    #rmTooltip: $target, $tooltipEl ->

  hoverStateByEvent =
    mouseenter: true
    mouseleave: false

  # I need to track info per-tooltip, e.g. to avoid
  # reopening an open tooltip
  # solution: a page-global tooltip counter providing ids.
  ttNextId = 0

  Backbone.Factlink.TooltipJQ = (cfg) ->

    cfg = $.extend defaults, cfg
    ttId = ttNextId++
    ttIdStr = 'tooltipData-' + ttId

    hoverTarget = (e) ->
      console.log e
      target = $(e.currentTarget)
      ttData = target.data(ttIdStr) || {}
      ttData.inTarget = hoverStateByEvent[e.type]

      shouldShow = ttData.inTarget || ttData.inTooltip

      if shouldShow && !ttData.showing then
        ttData.showing = true
        target.data(ttIdStr, ttData)
        ttData.$tooltipEl = cfg.mkTooltip $(e.target)
        cfg.$el.hoverIntent
          timeout: cfg.closingtimeout
          over: hoverTooltip

      else if showing && !shouldShow then
        ttData.showing = false
        target.removeData(ttIdStr)
        cfg.rmTooltip

    hoverTooltip = (e) ->


    cfg.$el.hoverIntent
      timeout: cfg.closingtimeout
      selector: cfg.selector
      over: hoverTarget
