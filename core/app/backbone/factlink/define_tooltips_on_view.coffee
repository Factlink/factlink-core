Backbone.Factlink ||= {}

#This function registers a tooltip handler for a marionette
#view.  Whenever a user hover(Intent)s over an element with
#the given selector, a new tooltip is filled with a view
#created by the given callback.

#options:
#  parentView: the marionette view owning this tooltip
#  tooltipViewFactory: -> called to created a view on hover
#  $target: jquery node which when hovered over should show tooltip
#  $offsetParent: a dom node within which to position the
#    tooltip with respect to the target (hovered) node.
#  positioning: options for PositionedRegion.

Backbone.Factlink.defineTooltipsOnView = (options) ->
  positionedRegion = null

  tooltipOptions =
    $target: options.$target

    showTooltip: ($target) ->
      popoverOptions = _.defaults
        contentView: options.tooltipViewFactory(), options.positioning
      positionedRegion =
        new Backbone.Factlink.PositionedRegion _.extend options.positioning,
          fadeTime: 100
      positionedRegion.bindToElement $target, options.$offsetParent
      positionedRegion.show new PopoverView popoverOptions
      positionedRegion.updatePosition()

      positionedRegion.$el

    hideTooltip: -> positionedRegion?.resetFade()

  tooltipHandler = Backbone.Factlink.defineTooltip tooltipOptions

  options.parentView.on 'close', tooltipHandler.close
