#= require jquery.hoverIntent

Backbone.Factlink ||= {}
do ->
  defaults =
    closingtimeout: 300
    #$el: owner
    #selector: what to hover over
    #mkTooltip: $el, $target -> $tooltip
    #rmTooltip: $el, $target, $tooltip ->

  ttCounter = 0

  #returns an object with a close method which when called
  #removes all open tooltips
  Backbone.Factlink.TooltipJQ = (cfg) ->
    uid = ttCounter++
    uidStr = 'tooltipUid-' + uid
    instCounter = 0
    instances = {}

    $el = cfg.$el
    _.defaults cfg, defaults

    openInstance = ($target) ->
      instId = 'tt' + instCounter++
      inTooltip = false
      inTarget = true

      $tooltip = cfg.mkTooltip $el, $target
      $tooltip.hoverIntent
        timeout: cfg.closingtimeout
        over: -> inTooltip = true; check()
        out: -> inTooltip = false; check()

      check = -> remove() if !(inTarget || inTooltip)
      remove = ->
        delete instances[instId]
        cfg.rmTooltip $el, $target, $tooltip
        $target.removeData(uidStr)
      $target.on 'remove', remove

      instances[instId] =
        remove: remove
        setTargetHover: (state) -> inTarget = state; check()

      $target.data(uidStr, instId)

    hoverTarget = (inTarget) -> (e) ->
      $target = $(e.currentTarget)
      ttActions = instances[$target.data(uidStr)]
      if ttActions
        ttActions.setTargetHover inTarget
      else if inTarget
        openInstance $target

    $el.hoverIntent
      timeout: cfg.closingtimeout
      selector: cfg.selector
      over: hoverTarget true
      out: hoverTarget false

    close: -> for id, ttActions of instances
      ttActions.remove()

  $ ->
    Backbone.Factlink.TooltipJQ
      $el: $('body')
      selector: 'a'
      mkTooltip: ($el, $target) ->
        $('<span class="testTooltip">This is a <a href="#">Link!</a></span>')
          .append($('<b>kill</b>').on('click', (e) ->
            e.stopPropagation()
            $target.remove()))
          .insertAfter($target)
      rmTooltip: ($el, $target, $tooltip) ->
        $tooltip.remove()
