Backbone.Factlink ||= {}

Backbone.Factlink.makeTooltipForView = (parentView, options) ->
  _.defaults options,
    $offsetParent: parentView.$el
    $tooltipElement: parentView.$(options.selector)

  tooltipOpener = new Backbone.Factlink.TooltipOpener options
  tooltipOpener.render()

  parentView.on 'close', => tooltipOpener.close()
  parentView.on 'removeTooltips', => tooltipOpener.close()
