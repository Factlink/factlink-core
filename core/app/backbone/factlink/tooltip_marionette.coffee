Backbone.Factlink ||= {}

do ->
  #options:
  #  parentView: marionette view
  #  tooltipViewFactory: -> view
  #  selector: selector identifying what can be hovered over.

  Backbone.Factlink.Tooltip = (options) ->
    positionedRegion = null


    maker = ($el, $target) ->
      throw "Cannot open duplicate tooltip" if positionedRegion?
      regionOptions = _.extend {}, options,
        contentView: options.tooltipViewFactory()

      positionedRegion =
        new Backbone.Factlink.PositionedRegion regionOptions
      positionedRegion.show new PopoverView regionOptions
      positionedRegion.bindToElement($target, $el)
      positionedRegion.updatePosition()
      positionedRegion.$el

    remover = ->
      positionedRegion.reset()
      positionedRegion = null


    closeHandler = Backbone.Factlink.TooltipJQ
      $el: options.parentView.$el
      selector: options.selector
      makeTooltip: maker
      removeTooltip: remover

    options.parentView.on 'close', closeHandler.close




