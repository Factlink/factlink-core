class SearchResultEmptyView extends Backbone.Marionette.ItemView
  template:
    text: "<p>Sorry, your search didn't return any results.</p>"

class window.SearchResultView extends Backbone.Marionette.CompositeView
  tagName: "div"
  className: "search-results"
  template: "search_results/_search_results"
  emptyView: SearchResultEmptyView
  itemViewContainer: ".results"

  buildItemView: (item, ItemView, itemViewOptions) ->
    if ItemView == SearchResultEmptyView
      new ItemView
    else
      options = _.extend( { model: item}, itemViewOptions)
      getSearchResultItemView(options)


  emptyViewOn: -> @$("div.no_results").show()
  emptyViewOff: -> @$("div.no_results").hide()
