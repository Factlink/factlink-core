#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}
  #$el: owner
  #selector: what to hover over
  #makeTooltip: $el, $target -> $tooltip
  #removeTooltip: $el, $target, $tooltip ->

defaults =
closingtimeout = 500
definitionCounter = 0

#returns an object with a close method which when called
#removes all open tooltips
Backbone.Factlink.defineTooltips = (options) ->
  definitionIdStr = 'tooltipUid-' + definitionCounter++
  instCounter = 0 #one call can cause multiple tooltips
  #we track each tooltip using the instCounter and store them
  #in `instances`: this means we can close them not just
  #in reponse to an event handler, but also on request
  instances = {}

  $el = options.$el
  _.defaults options, defaults

  openInstance = ($target) ->
    instId = 'tt' + instCounter++
    inTooltip = false
    inTarget = true #opened on hover over target

    $tooltip = options.makeTooltip $el, $target
    $tooltip.hoverIntent
      timeout: closingtimeout
      over: -> inTooltip = true; check()
      out: -> inTooltip = false; check()

    check = -> remove() if !(inTarget || inTooltip)
    remove = ->
      delete instances[instId]
      options.removeTooltip $el, $target, $tooltip
      $target.removeData(definitionIdStr)

    instances[instId] =
      remove: remove
      setTargetHover: (state) -> inTarget = state; check()

    $target.data(definitionIdStr, instId)

  hoverTarget = (inTarget) -> (e) ->
    $target = $(e.currentTarget)
    ttActions = instances[$target.data(definitionIdStr)]
    if ttActions #this is a known (i.e. open) tooltip
      ttActions.setTargetHover inTarget
    else if inTarget #target has no tooltip but is hovered
      openInstance $target

  $el.hoverIntent
    timeout: closingtimeout
    selector: options.selector
    over: hoverTarget true
    out: hoverTarget false

  close: -> for id, ttActions of instances
    ttActions.remove()

