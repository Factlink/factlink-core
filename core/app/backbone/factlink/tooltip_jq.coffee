#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}


#returns an object with a close method which when called
#removes all open tooltips
class Backbone.Factlink.TooltipJQ

  defaults =
    closingtimeout: 500
    #$el: owner
    #selector: what to hover over
    #makeTooltip: $el, $target -> $tooltip
    #removeTooltip: $el, $target, $tooltip ->

  ttCounter = 0 #each call to TooltipJQ gets its own id based on this.

  constructor: (options) ->
    @_options = options

    @_uid = ttCounter++
    @_uidStr = 'tooltip_Uid-' + @_uid
    @_instCounter = 0 #one call can cause multiple tooltips
    #we track each tooltip using the @_instCounter and store them
    #in `@_instances`: this means we can close them not just
    #in reponse to an event handler, but also on request
    @_instances = {}

    _.defaults @_options, defaults

    @_options.$el.hoverIntent
      timeout: @_options.closingtimeout
      selector: @_options.selector
      over: @_hoverTarget true
      out: @_hoverTarget false

  _openInstance: ($target) ->
    instId = 'tt' + @_instCounter++
    inTooltip = false
    inTarget = true #opened on hover over target

    $tooltip = @_options.makeTooltip @_options.$el, $target
    $tooltip.hoverIntent
      timeout: @_options.closingtimeout
      over: -> inTooltip = true; check()
      out: -> inTooltip = false; check()

    check = -> remove() if !(inTarget || inTooltip)
    remove = =>
      delete @_instances[instId]
      @_options.removeTooltip @_options.$el, $target, $tooltip
      $target.removeData(@_uidStr)

    @_instances[instId] =
      remove: remove
      setTargetHover: (state) -> inTarget = state; check()

    $target.data(@_uidStr, instId)

  _hoverTarget: (inTarget) ->
    (e) =>
      $target = $(e.currentTarget)
      ttActions = @_instances[$target.data(@_uidStr)]
      if ttActions #this is a known (i.e. open) tooltip
        ttActions.setTargetHover inTarget
      else if inTarget #target has no tooltip but is hovered
        @_openInstance $target

  close: ->
    ttActions.remove() for id, ttActions of @_instances
