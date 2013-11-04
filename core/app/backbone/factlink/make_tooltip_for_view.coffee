Backbone.Factlink ||= {}

Backbone.Factlink.makeTooltipForView = (parentView, options) ->
  _.defaults options, $offsetParent: parentView.$el

  tooltipOpener = new Backbone.Factlink.TooltipOpener _.extend {},
    $tooltipElement: parentView.$(options.selector), options

  tooltipOpener.render()

  parentView.on 'close', => tooltipOpener.close()
  parentView.on 'removeTooltips', => tooltipOpener.close()
