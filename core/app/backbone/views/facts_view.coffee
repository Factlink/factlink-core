class window.FactsView extends AutoloadingCompositeView
  _.extend @prototype, ToggleMixin

  className: "facts-view"
  itemViewContainer: ".facts"
  itemView: FactView

  template: "channels/facts"

  initialize: (options) ->
    @addShowHideToggle "loadingIndicator", "div.loading"
    @collection.on "startLoading", @loadingIndicatorOn, this
    @collection.on "stopLoading", @loadingIndicatorOff, this

  emptyViewOn: ->
    @someEmptyView = @options.empty_view || new EmptyTopicView
    @$("div.no_facts").html @someEmptyView.render().el

  emptyViewOff: ->
    @someEmptyView.close()
    delete @someEmptyView
