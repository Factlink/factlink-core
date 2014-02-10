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

  results_per_page: 20  # WARNING: coupling with search_controller.rb

  initialize: ->
    @collection.on 'add', =>
      @$('.js-results-capped-message').toggle !! (@collection.length == @results_per_page)

  templateHelpers: =>
    query: @collection.query()
    results_per_page: @results_per_page

  buildItemView: (item, ItemView, itemViewOptions) ->
    if ItemView == SearchResultEmptyLoadingView
      new ItemView collection: @collection
    else
      options = _.extend( { model: item}, itemViewOptions)
      @searchResultItemView(options)

  searchResultItemView: (options) ->
    switch options.model.get("the_class")
      when "FactData"
        new ReactView
          component: ReactFact
            model: new Fact(options.model.get("the_object"))
      when "FactlinkUser"
        new UserSearchView(model: new User(options.model.get("the_object")))
      else
        console.info "Unknown class of searchresult: ", options.model.get("the_class")
        new Backbone.View
