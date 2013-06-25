Backbone.Factlink ||= {}

Backbone.Factlink.makeTooltipForView = (options) ->
  _.defaults options, $offsetParent: options.parentView.$el
  _.defaults options.positioning, fadeTime: 100

  positionedRegion =
    new Backbone.Factlink.PositionedRegion options.positioning

  makeTooltip = ($el, $target) ->
    popoverOptions = _.defaults
      contentView: options.tooltipViewFactory(),
      options.positioning

    positionedRegion.bindToElement $target, options.$offsetParent
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

