Backbone.Factlink ||= {}

#options:
#  parentView: marionette view
#  tooltipViewFactory: -> view
#  selector: selector identifying what can be hovered over.
#  $offsetParent: a dom node within which to position the
#    tooltip with respect to the target (hovered) node. By
#    default, uses parentView.$el.

Backbone.Factlink.Tooltip = (options) ->
  positionedRegion =
    new Backbone.Factlink.PositionedRegion options.positioning

  maker = ($el, $target) ->
    popoverOptions = _.defaults
      contentView: options.tooltipViewFactory(),
      options.positioning


    positionedRegion.bindToElement $target,
      options.$offsetParent || $el
    positionedRegion.show new PopoverView popoverOptions
    positionedRegion.updatePosition()
    positionedRegion.$el

  remover = ->
    positionedRegion.resetFade()


  closeHandler = Backbone.Factlink.TooltipJQ
    $el: options.parentView.$el
    selector: options.selector
    makeTooltip: maker
    removeTooltip: remover

  options.parentView.on 'close', closeHandler.close




