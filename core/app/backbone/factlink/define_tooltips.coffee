#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}

closingtimeout = 500
definitionCounter = 0

Backbone.Factlink.defineTooltips = (options) ->
  #$container: context for selector
  #selector: what to hover over
  #showTooltip: $container, $target -> $tooltip
  #hideTooltip: $container, $target, $tooltip ->

  #returns: object with close method that closes all open tooltips stops
  #   opening new ones

  definitionId = 'tooltipUid-' + definitionCounter++
  instanceCounter = 0
  instances = {}
  $container = options.$container

  openInstance = ($target) ->
    instId = 'tt' + instanceCounter++
    mouseInTooltip = false
    mouseInTarget = true

    $tooltip = options.showTooltip $container, $target
    $tooltip.hoverIntent
      timeout: closingtimeout
      over: -> mouseInTooltip = true; check()
      out: -> mouseInTooltip = false; check()

    check = -> close() if !(mouseInTarget || mouseInTooltip)
    close = ->
      delete instances[instId]
      options.hideTooltip $container, $target, $tooltip
      $target.removeData(definitionId)

    instances[instId] =
      close: close
      setTargetHover: (state) -> mouseInTarget = state; check()

    $target.data(definitionId, instId)

  onTargetHover = (mouseInTarget) -> (e) ->
    $target = $(e.currentTarget)
    openedInstance = instances[$target.data(definitionId)]
    if openedInstance
      openedInstance.setTargetHover mouseInTarget
    else if mouseInTarget
      openInstance $target

  $container.hoverIntent
    timeout: closingtimeout
    selector: options.selector
    over: onTargetHover true
    out: onTargetHover false

  close: ->
    openInstance.close() for id, openInstance of instances
    $container.off(".hoverIntent") #unfortunately, we can't do better than this.
