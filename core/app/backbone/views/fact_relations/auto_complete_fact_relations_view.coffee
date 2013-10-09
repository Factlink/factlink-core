class window.AutoCompleteFactRelationsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-fact-relations"

  events:
    'click .js-switch-to-factlink': 'switchToComment'

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: 'fact_relations/auto_complete'

  ui:
    submit: '.js-post'

  initialize: ->
    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options) => new AutoCompleteSearchFactRelationsView _.extend {}, options,
        recent_collection: @options.recent_collection
      search_collection: new FactRelationSearchResults [],
        fact_id: @options.fact_id
        recent_collection: @options.recent_collection
      filtered_search_collection: new FilteredFactRelationSearchResults
      placeholder: @placeholder(@options.type)

    @listenTo @_text_input_view, 'focus', @focus
    @listenTo @model, 'change', @queryChanges

  placeholder: (type) ->
    if type == "believes"
      "The Factlink above is true because:"
    else
      "The Factlink above is false because:"

  addCurrent: ->
    selected_fact_attributes = @_search_list_view.currentActiveModel().attributes
    return unless selected_fact_attributes?

    @createFactRelation new FactRelation
      evidence_id: selected_fact_attributes.id
      from_fact: selected_fact_attributes
      created_by: currentUser.toJSON()
      type: @options.type

  switchToComment: ->
    @$el.removeClass 'active'
    @trigger 'switch_to_comment_view'

    mp_track "Evidence: Switching to comment"

  createFactRelation: (fact_relation) ->
    return if @submitting
    @disableSubmit()
    @trigger 'createFactRelation', fact_relation, => @enableSubmit()

  focus: ->
    mp_track "Evidence: Search focus"

  reset: ->
    @model.set text: ''

  queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching"

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text('Post Factlink')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')
