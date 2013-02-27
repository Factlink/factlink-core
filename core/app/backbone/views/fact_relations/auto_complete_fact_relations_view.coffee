class window.AutoCompleteFactRelationsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-fact-relations"

  events:
    "click .js-post": "addNew"
    'click .js-switch': 'switchCheckboxClicked'

  regions:
    'wheel_region': '.fact-wheel'
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: 'fact_relations/auto_complete'

  initialize: (options) ->
    recent_collection = options.recent_collection

    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options) => new AutoCompleteSearchFactRelationsView _.extend {}, options,
        recent_collection: recent_collection
      search_collection: => new FactRelationSearchResults([], fact_id: options.fact_id)
      placeholder: @placeholder(options.type)

    @bindTo @_text_input_view, 'focus', @focus, @
    @bindTo @model, 'change', @queryChanges, @

  placeholder: (type) ->
    if type == "supporting"
      "The Factlink above is true because:"
    else
      "The Factlink above is false because:"

  onRender: ->
    @wheel = new Wheel()
    @wheel_region.show new PersistentWheelView(model: @wheel)

  addCurrent: ->
    selected_fact_base = @_search_list_view.currentActiveModel().attributes

    if selected_fact_base?
      @addSelected(selected_fact_base)
    else
      @addNew()

  addNew: ->
    text = @model.get('text')

    fact = new Fact
      displaystring: text
      opinion: @wheel.userOpinion()
      fact_wheel: @wheel.toJSON()

    @trigger 'createFactRelation', new FactRelation
      displaystring: text
      fact_base: fact.toJSON()
      created_by: currentUser.toJSON()

  switchCheckboxClicked: (e) ->
    @trigger 'switch_to_comment_view', @model.get('text')
    e.preventDefault()
    e.stopPropagation()

    mp_track "Evidence: Switching to comment"

  addSelected: (selected_fact_base)->
    @trigger 'createFactRelation', new FactRelation
      evidence_id: selected_fact_base.id
      fact_base: selected_fact_base
      created_by: currentUser.toJSON()

  setQuery: (text) -> @model.set text: text

  focus: ->
    @$el.addClass 'active'

    mp_track "Evidence: Search focus"

  reset: ->
    @setQuery ''
    @wheel.reset()
    @wheel_region.currentView.render()

  queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching"
