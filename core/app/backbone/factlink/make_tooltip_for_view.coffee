Backbone.Factlink ||= {}

class TooltipCreator
  constructor: (@$offsetParent, @positioning, @tooltipViewFactory)->
    region_options = _.defaults fadeTime: 100, positioning
    @positionedRegion = new Backbone.Factlink.PositionedRegion region_options

  createTooltip: ($target) ->
    popoverOptions = _.defaults
      contentView: @tooltipViewFactory(),
      @positioning

    @positionedRegion.bindToElement $target, @$offsetParent
    @positionedRegion.show new PopoverView popoverOptions
    @positionedRegion.updatePosition()

    @positionedRegion.$el

  removeTooltip: ->
    @positionedRegion.resetFade()


Backbone.Factlink.makeTooltipForView = (parentView, options) ->
  _.defaults options, $offsetParent: parentView.$el

  tooltipCreator = new TooltipCreator options.$offsetParent,
    options.positioning, options.tooltipViewFactory

  tooltipOpener = new Backbone.Factlink.TooltipOpener
    $container: parentView.$el
    selector: options.selector
    tooltipCreator: tooltipCreator

  tooltipOpener.render()

  parentView.on 'close', => tooltipOpener.close()

