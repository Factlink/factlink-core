Backbone.Factlink ||= {}


class TooltipCreator
  constructor: (@$offsetParent, @positioning, @tooltipViewFactory)->
    @positionedRegion ?=
      new Backbone.Factlink.PositionedRegion @positioning

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


Backbone.Factlink.makeTooltipForView = (options) ->
  _.defaults options, $offsetParent: options.parentView.$el
  _.defaults options.positioning, fadeTime: 100

  tooltipCreator = new TooltipCreator options.$offsetParent,
    options.positioning, options.tooltipViewFactory

  tooltipOpener = new Backbone.Factlink.TooltipOpener
    $container: options.parentView.$el
    selector: options.selector
    tooltipCreator: tooltipCreator

  tooltipOpener.render()

  options.parentView.on 'close', => tooltipOpener.close()

