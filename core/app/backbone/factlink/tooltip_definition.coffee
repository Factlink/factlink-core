#= require jquery.hoverIntent

#BUG/KNOWN LIMITATION: hoverIntent supports only one handler
#per event.  This means that you certainly cannot support
#more than 1 tooltip per element, but perhaps also not more
#than one per owner.  The workaround is likely to not use
#hoverIntent (sigh), if we ever need this.


Backbone.Factlink ||= {}

#This class defines how tooltips should be shown for elements matching
#a selector within $container.  There can be multiple definitions.  Each
#definition can (potentially) show multiple tooltips.

class Backbone.Factlink.TooltipDefinition
  defaults = closingtimeout: 500
  ttCounter = 0 #each TooltipDefinition gets its own id based on this.

  #$container:   the owning element.
  #selector:     elements inside $container matching selector show tooltips
  #makeTooltip:  callback:  $container, $target -> $tooltip
  #   called when a tooltip is to be shown.  TooltipDefinition will
  #   not alter, add or show this element: you should do that.
  #removeTooltip: callback: $container, $target, $tooltip ->
  #   called when an open tooltip should be hidden.  TooltipDefinition
  #   does not alter, remove or hide this element: you should do that.

  constructor: (options) ->
    @_options = _.defaults options, defaults

    @_uid = ttCounter++
    @_uidStr = 'tooltip_Uid-' + @_uid
    @_instCounter = 0 #one call can cause multiple tooltips
    #we track each tooltip using the @_instCounter and store them
    #in `@_instances`: this means we can close them not just
    #in reponse to an event handler, but also on request
    @_instances = {}

    @_options.$container.hoverIntent
      timeout: @_options.closingtimeout
      selector: @_options.selector
      over: @_hoverTarget true
      out: @_hoverTarget false

  close: ->
    ttActions.remove() for id, ttActions of @_instances
    @_instances = null #reuse hereafter is a bug: this causes a crash then.
    @_options.$container.off(".hoverIntent") #unfortunately, we can't do better than this.

  _openInstance: ($target) ->
    console.log @_options, $target
    instId = 'tt' + @_instCounter++
    $target.data(@_uidStr, instId)
    @_instances[instId] =
      new TooltipInstance @_options, $target, ($tooltip) =>
        delete @_instances[instId]
        $target.removeData(@_uidStr)
        @_options.removeTooltip @_options.$container, $target, $tooltip

  _hoverTarget: (inTarget) ->
    (e) =>
      $target = $(e.currentTarget)
      ttActions = @_instances[$target.data(@_uidStr)]
      if ttActions #this is a known (i.e. open) tooltip
        ttActions.setTargetHover inTarget
      else if inTarget #target has no tooltip but is hovered
        @_openInstance $target

class TooltipInstance #only local!
  constructor: (@_options, @$target, @closeCallback) ->
    @_inTooltip = false
    @_inTarget = true #opened on hover over target

    @_$tooltip = @_options.makeTooltip @_options.$container, $target
    @_$tooltip.hoverIntent
      timeout: @_options.closingtimeout
      over: => @_inTooltip = true; @_check()
      out: => @_inTooltip = false; @_check()

  _check: -> @closeCallback(@_$tooltip) if !(@_inTarget || @_inTooltip)

  setTargetHover: (state) -> @_inTarget = state; @_check()

