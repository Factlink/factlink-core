class SearchResultEmptyView extends Backbone.Marionette.ItemView
  template: "search_results/search_results_empty"
  templateHelpers: => loading: @options.loading

class window.SearchResultView extends Backbone.Marionette.CompositeView
  tagName: "div"
  className: "search-results"
  template: "search_results/search_results"
  emptyView: SearchResultEmptyView
  itemViewContainer: ".results"
  itemViewOptions: => type: @options.type

  initialize: -> @collection.on 'reset', => @options.loading = false

  buildItemView: (item, ItemView, itemViewOptions) ->
    if ItemView == SearchResultEmptyView
      new ItemView loading: @options.loading
    else
      options = _.extend( { model: item}, itemViewOptions)
      getSearchResultItemView(options)
