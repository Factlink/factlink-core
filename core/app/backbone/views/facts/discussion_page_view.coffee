class window.DiscussionPageView extends TabbedMainRegionLayout
  onRender: ->
    @model.fetch
      success: (model, response) =>
        @contentRegion.show new DiscussionView(model: model, tab: @options.tab)
      error: => FactlinkApp.NotificationCenter.error("This Factlink could not be found. <a onclick='history.go(-1);$(this).closest(\"div.alert\").remove();'>Click here to go back.</a>")

    @titleRegion.show new ExtendedFactTitleView model: @model, back_button: @options.back_button
