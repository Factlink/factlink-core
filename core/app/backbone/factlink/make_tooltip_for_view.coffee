Backbone.Factlink ||= {}

#This function registers a tooltip handler for a marionette
#view.  Whenever a user hover(Intent)s over an element with
#the given selector, a new tooltip is filled with a view
#created by the given callback.

#options:
#  parentView: the marionette view owning this tooltip
#  tooltipViewFactory: -> called to created a view on hover
#  selector: selector identifying what can be hovered over.
#  $offsetParent: a dom node within which to position the
#    tooltip with respect to the target (hovered) node.
#    If unspecified, uses parentView.$el.

Backbone.Factlink.makeTooltipForView = (options) ->
  positionedRegion =
    new Backbone.Factlink.PositionedRegion _.defaults options.positioning,
      fadeTime: 100

  makeTooltip = ($el, $target) ->
    popoverOptions = _.defaults
      contentView: options.tooltipViewFactory(),
      options.positioning

    positionedRegion.bindToElement $target,
      options.$offsetParent || $el
    positionedRegion.show new PopoverView popoverOptions
    positionedRegion.updatePosition()
    positionedRegion.$el

  tooltipDefinition = new Backbone.Factlink.TooltipDefinition
    $container: options.parentView.$el
    selector: options.selector
    makeTooltip: makeTooltip
    removeTooltip: -> positionedRegion.resetFade()

  tooltipDefinition.render()

  options.parentView.on 'close', tooltipDefinition.close

