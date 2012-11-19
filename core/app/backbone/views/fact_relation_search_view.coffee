class window.FactRelationSearchView extends Backbone.Factlink.PlainView
  events:
    "keyup input": "doSearchOrSubmit"
    "click li.add": "addNewFactRelation"

  template: "fact_relations/evidence_search"

  initialize: (options) ->
    @_busyAdding = false
    @_lastKnownSearch = ""
    @_searchResultViews = []

  onRender: ->
    if @options.factRelations.type == "supporting"
      @$(".add-evidence.supporting").show()
    else
      @$(".add-evidence.weakening").show()

  cancelSearch: (e) ->
    @truncateSearchContainer()
    @$("input", @el).val ""

  doSearchOrSubmit: (e) ->
    if e.keyCode == 13
      searchVal = @$("input:visible", @el).val()
      if searchVal.trim().length > 0
        @_lastKnownSearch = searchVal
        @addNewFactRelation()
    else
      @doSearch()

  doSearch: _.throttle(->
    searchVal = @$("input:visible", @el).val()
    if searchVal.length < 2 and searchVal isnt @_lastKnownSearch
      @truncateSearchContainer()
      return
    @_lastKnownSearch = searchVal
    @setLoading()
    $.ajax
      url: @options.factRelations.fact.url() + "/evidence_search"
      data:
        s: searchVal

      success: (searchResults) =>
        @parseSearchResults(searchResults)
        @$("li.add>span.word").text(searchVal).closest("li").show()
        mp_track "Evidence: Search",
          type: @options.factRelations.type

        @stopLoading()
  , 300)

  parseSearchResults: (searchResults) =>
    $results = @$(".search-results")
    $results.hide()
    @$el.removeClass "results_found"
    @truncateSearchContainer()
    _.forEach searchResults, ((searchResult) =>
      unless @options.factRelations.containsFactWithId(parseInt(searchResult.id, 10))
        view = new FactRelationSearchResultView(
          model: new FactRelationSearchResult(searchResult)
          
          # Give the search result a reference to the FactRelation collection
          factRelations: @options.factRelations
          parentView: this
        )
        view.render()
        @$el.addClass "results_found"
        $results.show().find("li.loading").after view.el
        @_searchResultViews.push view
    ), this

  addNewFactRelation: ->
    if @_busyAdding
      return
    else
      @_busyAdding = true
    factRelations = @options.factRelations
    @setAddingIndicator()
    $.ajax
      url: factRelations.url()
      type: "POST"
      data:
        fact_id: factRelations.fact.get("id")
        displaystring: @_lastKnownSearch

      success: (newFactRelation) =>
        mp_track "Evidence: Create",
          factlink_id: @options.factRelations.fact.id
          type: @options.factRelations.type

        factRelations.add new factRelations.model(newFactRelation),
          highlight: true

        @_busyAdding = false
        @cancelSearch()
        @stopAddingIndicator()

      error: =>
        @_busyAdding = false
        @cancelSearch()
        @stopAddingIndicator()
        alert "Something went wrong while adding evidence"


  truncateSearchContainer: ->
    _.forEach @_searchResultViews, (view) ->
      view.close()

    @$("li.add").hide()
    @_searchResultViews = []

  setLoading: ->
    @$("li.loading").show()

  stopLoading: ->
    @$("li.loading").hide()

  setAddingIndicator: ->
    @$(".add img").show()
    @$(".add .add-message").text "Adding"

  stopAddingIndicator: ->
    @$(".add img").hide()
    @$(".add .add-message").text "Add"
