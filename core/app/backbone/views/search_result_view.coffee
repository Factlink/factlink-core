class window.SearchResultView extends Backbone.Marionette.CompositeView
  tagName: "div"
  className: "search-results"
  template: "search_results/_search_results"
  itemViewContainer: ".results"

  buildItemView: (item, itemView, itemViewOptions) ->
    options = _.extend( { model: item}, itemViewOptions)
    getSearchResultItemView(options)


  emptyViewOn: -> @$("div.no_results").show()
  emptyViewOff: -> @$("div.no_results").hide()
