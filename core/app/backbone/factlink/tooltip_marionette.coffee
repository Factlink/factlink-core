Backbone.Factlink ||= {}

#options:
#  parentView: the marionette view owning this tooltip
#  tooltipViewFactory: -> called to created a view on hover
#  selector: selector identifying what can be hovered over.
#  $offsetParent: a dom node within which to position the
#    tooltip with respect to the target (hovered) node.
#    If unspecified, uses parentView.$el.

Backbone.Factlink.Tooltip = (options) ->
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

  closeHandler = Backbone.Factlink.TooltipJQ
    $el: options.parentView.$el
    selector: options.selector
    makeTooltip: makeTooltip
    removeTooltip: -> positionedRegion.resetFade()

  options.parentView.on 'close', closeHandler.close




