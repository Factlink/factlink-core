Backbone.Factlink ||= {}

class TooltipCreator
  constructor: (@_$offsetParent, @_positioning, @_tooltipViewFactory)->

  createTooltip: ($target) ->
    @_ensureRegion()
    @_positionedRegion.bindToElement $target, @_$offsetParent
    @_positionedRegion.show @_tooltipView()
    @_positionedRegion.updatePosition()

    @_positionedRegion.$el

  removeTooltip: ->
    @_positionedRegion.resetFade() if @_positionedRegion

  _tooltipView: ->
    tooltipOptions = _.extend {},
      contentView: @_tooltipViewFactory(),
      @_positioning
    new PopoverView tooltipOptions

  _ensureRegion: ->
    if !@_positionedRegion?
      region_options = _.extend { fadeTime: 100 }, @_positioning
      @_positionedRegion = new Backbone.Factlink.PositionedRegion region_options


Backbone.Factlink.makeTooltipForView = (parentView, options) ->
  _.defaults options, $offsetParent: parentView.$el

  tooltipCreator = new TooltipCreator options.$offsetParent,
    options.positioning, options.tooltipViewFactory

  tooltipOpener = new Backbone.Factlink.TooltipOpener
    el: parentView.$(options.selector)
    tooltipCreator: tooltipCreator

  tooltipOpener.render()

  parentView.on 'close', => tooltipOpener.close()

