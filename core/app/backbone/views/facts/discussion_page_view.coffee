class window.DiscussionPageView extends TabbedMainRegionLayout
  initialize: ->
    @listenTo @model, "destroy", @on_destroy

  onRender: ->
    @model.fetch
      success: (model, response) =>
        @contentRegion.show new DiscussionView(model: model, tab: @options.tab)
      error: => FactlinkApp.NotificationCenter.error("This Factlink could not be found. <a onclick='history.go(-1);$(this).closest(\"div.alert\").remove();'>Click here to go back.</a>")

    @titleRegion.show new ExtendedFactTitleView model: @model, back_button: @options.back_button

  on_destroy: ->
    url = @options.back_button.get('url')
    if url
      FactlinkApp.NotificationCenter.success 'Factlink deleted.'
      Backbone.history.navigate(url, true)

