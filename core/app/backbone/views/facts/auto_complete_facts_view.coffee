class window.AutoCompleteFactsView extends AutoCompleteSearchView
  className: "auto-complete"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: 'facts/auto_complete_facts'

  initialize: ->
    @_recent_collection = new RecentlyViewedFacts
    @_recent_collection.fetch()

    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options) => new AutoCompleteSearchFactsView _.extend {}, options,
        recent_collection: @_recent_collection
      search_collection: new FactSearchResults [],
        fact_id: @options.fact_id
        recent_collection: @_recent_collection
      filtered_search_collection: new FilteredFactSearchResults
      placeholder: 'Search...'

    @listenTo @model, 'change', @queryChanges
    @on 'region:focus', -> @_text_input_view.focusInput()

  onRender: ->
    @_text_input_view.focusInput()

  addCurrent: ->
    selected_fact_attributes = @_search_list_view.currentActiveModel().attributes
    return unless selected_fact_attributes?

    @createFactRelation new FactRelation
      evidence_id: selected_fact_attributes.id
      from_fact: selected_fact_attributes
      created_by: currentUser.toJSON()
      type: @options.argumentTypeModel.get 'argument_type'

  createFactRelation: (fact_relation) ->
    return @showError() unless fact_relation.isValid()

    @options.addToCollection.add fact_relation

    fact_relation.save {},
      error: =>
        @options.addToCollection.remove fact_relation
        @showError()

      success: =>
        @reset()

        mp_track "Evidence: Added",
          factlink_id: @options.fact_id
          type: @options.argumentTypeModel.get 'argument_type'

  reset: ->
    @model.set text: ''

  queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching"

  showError: ->
    FactlinkApp.NotificationCenter.error 'Your #{Factlink.Global.t.factlink} could not be posted, please try again.'
