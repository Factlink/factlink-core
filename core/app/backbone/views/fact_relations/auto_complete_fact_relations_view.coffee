#= require ../auto_complete/search_view

class window.AutoCompleteFactRelationsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-fact-relations"

  events:
    "click div.auto-complete-search-list": "addCurrent"
    "click .js-post": "addNew"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template: 'fact_relations/auto_complete'

  initialize: ->
    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options)-> new AutoCompleteSearchFactRelationsView(options)
      search_collection: => new FactRelationSearchResults([], fact_id: @collection.fact.id)
      placeholder: @placeholder()

  placeholder: ->
    if @collection.type == "supporting"
      "The Factlink above is true because:"
    else
      "The Factlink above is false because:"

  addNew: ->
    text = @model.get('text')

    @trigger 'createFactRelation', new FactRelation
      displaystring: text
      fact_base: new Fact(displaystring: text).toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()
      fact_relation_authority: '1.0'

  addCurrent: ->
    selected_fact_base = @_search_list_view.currentActiveModel()

    if selected_fact_base?
      @trigger 'selected', new FactRelation
        evidence_id: selected_fact_base.id
        fact_base: selected_fact_base.toJSON()
        fact_relation_type: @collection.type
        created_by: currentUser.toJSON()
        fact_relation_authority: '1.0'
    else
      @addNew()

  setQuery: (text) -> @model.set text: text
