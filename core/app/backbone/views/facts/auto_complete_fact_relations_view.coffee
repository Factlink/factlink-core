#= require ../auto_complete/search_view

class window.AutoCompleteFactRelationsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-fact-relations"

  events:
    "click div.auto-complete-search-list": "addCurrent"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template: "auto_complete/box_without_results"

  initialize: ->
    if @collection.type == "supporting"
      placeholder = "The Factlink above is true because:"
    else
      placeholder = "The Factlink above is false because:"

    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options)-> new AutoCompleteSearchFactRelationsView(options)
      search_collection: => new FactRelationSearchResults([], fact_id: @collection.fact.id)
      placeholder: placeholder

  addCurrent: ->
    selected_result = @_search_list_view.currentActiveModel()
    console.log 'de collection: ', @collection

    if selected_result.get('new')?
      @collection.create
        displaystring: selected_result.get('displaystring')
        fact_base: new Fact(displaystring: selected_result.get('displaystring')).toJSON()
        fact_relation_type: @collection.type
    else
      @collection.create
        evidence_id: selected_result.id
        fact_base: selected_result
        fact_relation_type: @collection.type
