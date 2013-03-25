class SearchResultEmptyView extends Backbone.Marionette.ItemView
  template: "search_results/search_results_empty"

class SearchResultEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  emptyView: SearchResultEmptyView

class window.SearchResultView extends Backbone.Marionette.CompositeView
  className: "search-results"
  template: "search_results/search_results"
  emptyView: SearchResultEmptyLoadingView
  itemViewContainer: ".results"
  itemViewOptions: => type: @options.type

  buildItemView: (item, ItemView, itemViewOptions) ->
    if ItemView == SearchResultEmptyLoadingView
      new ItemView collection: @collection
    else
      options = _.extend( { model: item}, itemViewOptions)
      getSearchResultItemView(options)
