Backbone.Factlink ||= {}

class TooltipCreator
  constructor: (@_$offsetParent, @positioning, @_tooltipViewFactory)->
    region_options = _.extend {fadeTime: 100} , positioning
    @positionedRegion = new Backbone.Factlink.PositionedRegion region_options

  createTooltip: ($target) ->
    popoverOptions = _.extend {},
      contentView: @_tooltipViewFactory(),
      @positioning

    @positionedRegion.bindToElement $target, @_$offsetParent
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
    el: parentView.$(options.selector)
    tooltipCreator: tooltipCreator

  tooltipOpener.render()

  parentView.on 'close', => tooltipOpener.close()

