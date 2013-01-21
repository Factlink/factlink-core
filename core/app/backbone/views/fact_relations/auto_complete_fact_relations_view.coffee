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
    @initializeRecentCollection()

    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options) => new AutoCompleteSearchFactRelationsView _.extend {}, options,
        recentCollection: @recentCollection
      search_collection: => new FactRelationSearchResults([], fact_id: options.fact_id)
      placeholder: @placeholder(options.type)

    @bindTo @_text_input_view, 'focus', @focus, @
    @bindTo @_text_input_view, 'blur', @blur, @
    @bindTo @model, 'change', @updateRecentCollection, @

  placeholder: (type) ->
    if type == "supporting"
      "The Factlink above is true because:"
    else
      "The Factlink above is false because:"

  onRender: ->
    @wheel = new Wheel()
    @wheel_region.show new PersistentWheelView(model: @wheel)

  addCurrent: ->
    selected_fact_base = @_search_list_view.currentActiveModel()

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
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()

  switchCheckboxClicked: (e) ->
    @trigger 'switch_to_comment_view', @model.get('text')
    e.preventDefault()
    e.stopPropagation()

  addSelected: (selected_fact_base)->
    @trigger 'selected', new FactRelation
      evidence_id: selected_fact_base.id
      fact_base: selected_fact_base.toJSON()
      fact_relation_type: @collection.type
      created_by: currentUser.toJSON()

  setQuery: (text) -> @model.set text: text

  initializeRecentCollection: ->
    @recentCollection = new RecentlyViewedFactsCollection
    @bindTo @recentCollection, 'before:fetch', => @setLoading()
    @bindTo @recentCollection, 'reset', =>
      @unsetLoading()
      @updateRecentCollection()

  updateRecentCollection: ->
    @search_collection.reset @recentCollection.models if @model.get('text') == ''

  focus: ->
    @$el.addClass 'active'
    @recentCollection.fetch() if @model.get('text') == ''

  blur: ->
    @recentCollection.reset [] if @model.get('text') == ''

  reset: ->
    @setQuery ''
    @wheel.reset()
    @wheel_region.currentView.render()
