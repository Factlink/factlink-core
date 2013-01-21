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
      search_collection_modification_function: (search_collection) =>
        new CollectionUtils(@).union new Backbone.Collection, search_collection, @recentCollection

    @bindTo @_text_input_view, 'focus', @focus, @
    @bindTo @_text_input_view, 'blur', @blur, @
    @bindTo @model, 'change', @toggleActivateOnContentOrFocus, @

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
    @recentCollection = new Backbone.Collection []
    @bindTo @recentCollection, 'before:fetch', => @setLoading()
    @bindTo @recentCollection, 'reset', => @unsetLoading()

  fetchRecentCollection: ->
    unless @recentCollectionFetched
      @recentCollectionFetched = true
      @recentCollection.reset [new Fact {"link":"<a href=\"http://localhost:8080/?url=http%3A%2F%2Fexample.org%2F&amp;scrollto=6\" target=\"_blank\">the molecules that are not accessible to microbes persist and could have toxic effects</a>","fact_id":"6","url":"/the-molecules-that-are-not-accessible-to-microbes-persist-and-could-have-toxic-effects/f/6","id":"6","user_signed_in?":true,"i_am_fact_owner":true,"can_edit?":true,"scroll_to_link":null,"displaystring":"the molecules that are not accessible to microbes persist and could have toxic effects","fact_title":null,"fact_wheel":{"authority":"6.4","opinion_types":{"believe":{"percentage":50,"is_user_opinion":false},"doubt":{"percentage":25,"is_user_opinion":false},"disbelieve":{"percentage":25,"is_user_opinion":true}},"fact_id":"6"},"believe_percentage":50,"disbelieve_percentage":25,"doubt_percentage":25,"fact_url":"http://example.org/","proxy_scroll_url":"http://localhost:8080/?url=http%3A%2F%2Fexample.org%2F&scrollto=6"}]

  focus: ->
    @$el.addClass 'active'
    @fetchRecentCollection()

  reset: ->
    @setQuery ''
    @wheel.reset()
    @wheel_region.currentView.render()
